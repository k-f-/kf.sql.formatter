-- =============================================================================
-- 05-spark-specific.sql
-- Spark/Databricks specific features
-- =============================================================================

-- Backtick identifiers
SELECT 
    `customer id`,
    `first name`,
    `last name`,
    `email address`
FROM `customer data`;

-- named_struct (Databricks/Spark specific)
SELECT 
    id,
    named_struct(
        'name', customer_name,
        'email', email,
        'phone', phone
    ) as customer_info
FROM customers;

-- named_struct with nested structure
SELECT 
    order_id,
    named_struct(
        'customer', named_struct(
            'id', customer_id,
            'name', customer_name
        ),
        'shipping', named_struct(
            'address', shipping_address,
            'city', shipping_city,
            'zip', shipping_zip
        ),
        'total', order_total
    ) as order_details
FROM orders;

-- named_struct with CASE expressions
SELECT 
    id,
    named_struct(
        'status', CASE WHEN active THEN 'Active' ELSE 'Inactive' END,
        'tier', CASE 
            WHEN total_purchases > 10000 THEN 'Gold'
            WHEN total_purchases > 5000 THEN 'Silver'
            ELSE 'Bronze'
        END,
        'total', total_purchases
    ) as customer_status
FROM customers;

-- LATERAL VIEW with EXPLODE
SELECT 
    id,
    exploded_item
FROM source_table
LATERAL VIEW EXPLODE(item_array) t AS exploded_item;

-- LATERAL VIEW with multiple EXPLODE
SELECT 
    id,
    category,
    tag
FROM products
LATERAL VIEW EXPLODE(categories) c AS category
LATERAL VIEW EXPLODE(tags) t AS tag;

-- LATERAL VIEW OUTER
SELECT 
    id,
    exploded_value
FROM source_table
LATERAL VIEW OUTER EXPLODE(nullable_array) t AS exploded_value;

-- POSEXPLODE (position + explode)
SELECT 
    id,
    pos,
    value
FROM source_table
LATERAL VIEW POSEXPLODE(values_array) t AS pos, value;

-- Map functions
SELECT 
    id,
    MAP('key1', value1, 'key2', value2, 'key3', value3) as value_map
FROM source_table;

-- Map with named_struct values
SELECT 
    id,
    MAP(
        'primary', named_struct('name', name1, 'value', value1),
        'secondary', named_struct('name', name2, 'value', value2)
    ) as structured_map
FROM source_table;

-- TRANSFORM (Spark 3.0+)
SELECT 
    id,
    TRANSFORM(numbers, x -> x * 2) as doubled_numbers
FROM source_table;

-- FILTER on arrays
SELECT 
    id,
    FILTER(numbers, x -> x > 10) as filtered_numbers
FROM source_table;

-- AGGREGATE on arrays
SELECT 
    id,
    AGGREGATE(numbers, 0, (acc, x) -> acc + x) as sum_of_numbers
FROM source_table;

-- Struct access with dot notation
SELECT 
    id,
    customer_struct.name,
    customer_struct.email,
    customer_struct.address.city,
    customer_struct.address.zip
FROM customers_with_struct;

-- Array subscripting
SELECT 
    id,
    items[0] as first_item,
    items[SIZE(items) - 1] as last_item
FROM source_table;

-- Map subscripting
SELECT 
    id,
    properties['color'] as color,
    properties['size'] as size
FROM products;

-- COLLECT_LIST and COLLECT_SET aggregates
SELECT 
    customer_id,
    COLLECT_LIST(product_id) as purchased_products,
    COLLECT_SET(product_category) as unique_categories
FROM purchases
GROUP BY customer_id;

-- ARRAY_CONTAINS
SELECT 
    id,
    name
FROM products
WHERE ARRAY_CONTAINS(tags, 'featured');

-- Higher-order functions with complex expressions
SELECT 
    id,
    TRANSFORM(
        items,
        item -> named_struct(
            'id', item.id,
            'adjusted_price', item.price * 1.1,
            'discounted', item.price > 100
        )
    ) as processed_items
FROM orders;

-- Window function with array aggregation
SELECT 
    customer_id,
    order_date,
    COLLECT_LIST(product_id) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) as cumulative_products
FROM orders;

-- PIVOT (Spark SQL)
SELECT *
FROM (
    SELECT year, quarter, revenue
    FROM sales
)
PIVOT (
    SUM(revenue)
    FOR quarter IN ('Q1', 'Q2', 'Q3', 'Q4')
);

-- Table-valued functions
SELECT *
FROM RANGE(1, 100);

SELECT *
FROM EXPLODE(ARRAY(1, 2, 3, 4, 5));

-- Delta Lake operations (if using Delta)
SELECT 
    id,
    name,
    _change_type,
    _commit_version,
    _commit_timestamp
FROM table_changes('my_table', 0);

-- TABLESAMPLE
SELECT *
FROM large_table
TABLESAMPLE (10 PERCENT);

SELECT *
FROM large_table
TABLESAMPLE (1000 ROWS);

-- Hints (Spark SQL optimization)
SELECT /*+ BROADCAST(small_table) */
    l.id,
    l.value,
    s.reference
FROM large_table l
JOIN small_table s ON l.key = s.key;

SELECT /*+ MERGE(t1, t2) */
    t1.id,
    t2.value
FROM table1 t1
JOIN table2 t2 ON t1.id = t2.id;

-- Backticks with reserved keywords
SELECT 
    `select` as selection_column,
    `from` as from_column,
    `where` as where_column
FROM `table`;

-- Complex nested structure
SELECT 
    id,
    named_struct(
        'basic_info', named_struct(
            'name', name,
            'email', email
        ),
        'preferences', MAP(
            'color', favorite_color,
            'size', preferred_size
        ),
        'purchase_history', COLLECT_LIST(
            named_struct(
                'product_id', product_id,
                'purchase_date', purchase_date,
                'amount', amount
            )
        ) OVER (PARTITION BY customer_id ORDER BY purchase_date)
    ) as customer_profile
FROM customer_data;
