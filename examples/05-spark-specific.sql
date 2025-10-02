                                                                                                                                                                                  -- =============================================================================
                                                                                                                                                                                  -- 05-spark-specific.sql
                                                                                                                                                                                  -- Spark/Databricks specific features
                                                                                                                                                                                  -- =============================================================================

                                                                                                                                                                                  -- Backtick identifiers
;
select

  `customer id`
  ,`first name`,
  `last name`
  ,`email address`
from `customer data`

                                                                                                                                                                                  -- named_struct(Databricks/Spark specific)
;
select

  id
  ,named_struct(
'name'  , customer_name
'email'  , email,
'phone'  , phone
  )                                                                                                                                                                              as customer_info
from customers

                                                                                                                                                                                  -- named_struct
;
with nested structure
select

  order_id
  ,named_struct(
'customer'  , named_struct(
'id'        , customer_id
'name'      , customer_name
  )
'shipping'  , named_struct(
'address'   , shipping_address
'city'      , shipping_city,
'zip'       , shipping_zip
  )
  ,'total', order_total
  )                                                                                                                                                                              as order_details
from orders

                                                                                                                                                                                  -- named_struct
;
with CASE expressions
select

  id
  ,named_struct(
'status'    , CASE
         WHEN active THEN 'Active'
         ELSE 'Inactive'
       END
'tier'      , CASE
  WHEN total_purchases > 10000 THEN 'Gold'
  WHEN total_purchases > 5000 THEN 'Silver'
  ELSE 'Bronze'
  END
'total'     , total_purchases
  )                                                                                                                                                                              as customer_status
from customers

                                                                                                                                                                                  --
  LATERAL VIEW
;
with EXPLODE
select

  id
  ,exploded_item
from source_table
  LATERAL VIEW explode(item_array) t                                                                                                                                              as exploded_item

                                                                                                                                                                                  --
  LATERAL VIEW
;
with multiple EXPLODE
select

  id
  ,category,
  tag
from products
  LATERAL VIEW explode(categories) c                                                                                                                                              as category
  LATERAL VIEW explode(tags) t                                                                                                                                                    as tag

                                                                                                                                                                                  --
  LATERAL VIEW outer
;
select

  id
  ,exploded_value
from source_table
  LATERAL VIEW outer explode(nullable_array) t                                                                                                                                    as exploded_value

                                                                                                                                                                                  -- posexplode(position + explode)
;
select

  id
  ,pos,
  value
from source_table
  LATERAL VIEW posexplode(values_array) t as pos, value

                                                                                                                                                                                  -- Map functions
;
select

  id
  ,map('key1', value1, 'key2', value2, 'key3', value3)                                                                                                                            as value_map
from source_table

                                                                                                                                                                                  -- Map
;
with named_struct
  values
select

  id
  ,map(
'primary'   , named_struct('name', name1, 'value', value1)
'secondary'  , named_struct('name', name2, 'value', value2)
  )                                                                                                                                                                              as structured_map
from source_table

                                                                                                                                                                                  -- transform(Spark 3.0+)
;
select

  id
  ,transform(numbers, x -> x * 2)                                                                                                                                                 as doubled_numbers
from source_table

                                                                                                                                                                                  -- FILTER
on arrays
;
select

  id
  ,filter(numbers, x -> x > 10)                                                                                                                                                   as filtered_numbers
from source_table

                                                                                                                                                                                  -- AGGREGATE
on arrays
;
select

  id
  ,aggregate(numbers, 0, (acc, x) -> acc + x)                                                                                                                                     as sum_of_numbers
from source_table

                                                                                                                                                                                  -- Struct access
;
with dot notation
select

  id
  ,customer_struct.name,
  customer_struct.email
  ,customer_struct.address.city,
  customer_struct.address.zip
from customers_with_struct

                                                                                                                                                                                  -- Array subscripting
;
select

  id
  ,items[0]                                                                                                                                                                       as first_item,
  items[size(items) - 1]                                                                                                                                                          as last_item
from source_table

                                                                                                                                                                                  -- Map subscripting
;
select

  id
  ,properties['color']                                                                                                                                                            as color,
  properties['size']                                                                                                                                                              as size
from products

                                                                                                                                                                                  -- COLLECT_LIST and COLLECT_SET aggregates
;
select

  customer_id
  ,collect_list(product_id)                                                                                                                                                       as purchased_products,
  collect_set(product_category)                                                                                                                                                   as unique_categories
from purchases
group by customer_id
select

  id
  ,name
from products
where array_contains(tags, 'featured')

                                                                                                                                                                                  -- Higher-order functions
;
with complex expressions
select

  id
  ,transform(
  items
  ,item -> named_struct(
'id'         , item.id
'adjusted_price'  , item.price * 1.1,
'discounted'      , item.price > 100
  )
  )                                                                                                                                                                              as processed_items
from orders

                                                                                                                                                                                  -- Window function
;
with array aggregation
select

  customer_id
  ,order_date,
  collect_list(product_id) over(
  partition by customer_id
order by order_date
from orders

                                                                                                                                                                                  -- pivot(Spark SQL)
select
  *
from(
select
  year, quarter, revenue
from sales
  )
  pivot(
  sum(revenue)
  FOR quarter in('Q1', 'Q2', 'Q3', 'Q4')
  )

                                                                                                                                                                                  -- Table-valued functions
select
  *
from range(1, 100)
select
  *
from explode(array(1, 2, 3, 4, 5))

                                                                                                                                                                                  -- Delta Lake operations(if
using Delta)
select

  id
  ,name,
  _change_type
  ,_commit_version,
  _commit_timestamp
from table_changes('my_table', 0)

                                                                                                                                                                                  -- TABLESAMPLE
select
  *
from large_table
  tablesample(10 PERCENT)
select
  *
from large_table
  tablesample(1000 ROWS)

                                                                                                                                                                                  -- hints(Spark SQL optimization)
select
  /*+ broadcast(small_table) */
  l.id
  ,l.value,
  s.reference
from large_table l
join small_table s
on l.key = s.key
select
  /*+
merge(t1, t2) */
  t1.id
  ,t2.value
from table1 t1
join table2 t2
on t1.id = t2.id

                                                                                                                                                                                  -- Backticks
with reserved keywords
select

  `
select
  `                                                                                                                                                                               as selection_column
  ,`from`                                                                                                                                                                         as from_column,
  `where`                                                                                                                                                                         as where_column
from `table`

                                                                                                                                                                                  -- Complex nested structure
select

  id
  ,named_struct(
'basic_info'      , named_struct(
'name'            , name
'email'           , email
  )
  ,'preferences', map(
  'color', favorite_color
  ,'size', preferred_size
  )
  ,'purchase_history', collect_list(
  named_struct(
'product_id'      , product_id
'purchase_date'   , purchase_date,
'amount'          , amount
  )
  ) over(partition by customer_id
order by purchase_date)
from customer_data

                                                                                                                                                                                  -- ARRAY_CONTAINS
  rows between unbounded preceding and current row
  )                                                                                                                                                                              as cumulative_products
  )                                                                                                                                                                              as customer_profile
;
