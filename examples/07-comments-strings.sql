                                                                                                                                                                                                                                                                                                                     -- =============================================================================
                                                                                                                                                                                                                                                                                                                     -- 07-comments-strings.sql
                                                                                                                                                                                                                                                                                                                     -- Testing comment handling and strings containing SQL keywords
                                                                                                                                                                                                                                                                                                                     -- =============================================================================

                                                                                                                                                                                                                                                                                                                     -- Single line comment before
;
select

                                                                                                                                                                                                                                                                                                                     -- This is a comment
;
select
  *
from customers

                                                                                                                                                                                                                                                                                                                     -- Comment after
;
select
  keyword
;
select
                                                                                                                                                                                                                                                                                                                     -- inline comment
  customer_id
  ,name
from customers

                                                                                                                                                                                                                                                                                                                     -- Inline comments in column list
;
select

  customer_id,                                                                                                                                                                                                                                                                                                       -- Primary key
  name,                                                                                                                                                                                                                                                                                                              -- Customer full name
  email,                                                                                                                                                                                                                                                                                                             -- Contact email
created_at                                                                                                                                                                                                                                                                                                           -- Account creation timestamp
from customers

                                                                                                                                                                                                                                                                                                                     -- Block comment
  /*
  * This is a multi-line
  * block comment
  */
;
select
  *
from orders

  /* Inline block comment */
;
select
  *
from products

                                                                                                                                                                                                                                                                                                                     -- Comments in
where clause
;
select
  *
from orders
where status = 'active'                                                                                                                                                                                                                                                                                              -- Only active orders
  and order_date >= '2024-01-01'                                                                                                                                                                                                                                                                                     --
from this year
  and customer_id in(1, 2, 3);                                                                                                                                                                                                                                                                                       -- VIP customers only

                                                                                                                                                                                                                                                                                                                     -- Comments
;
with
join
select

  o.order_id
  ,c.customer_name                                                                                                                                                                                                                                                                                                   -- full name
from customers table
from orders o
join customers c                                                                                                                                                                                                                                                                                                     --
join to get customer details
on o.customer_id = c.customer_id;                                                                                                                                                                                                                                                                                    -- Match
on ID

                                                                                                                                                                                                                                                                                                                     -- Comment before
group by
;
select

  category
  ,count(*)                                                                                                                                                                                                                                                                                                          as product_count
from products
                                                                                                                                                                                                                                                                                                                     --
group by product category
group by category
select

  customer_id
  ,CASE
  WHEN total_orders > 100 THEN 'VIP'                                                                                                                                                                                                                                                                                 -- High volume
  WHEN total_orders > 50 THEN 'Premium'                                                                                                                                                                                                                                                                              -- Medium volume
  WHEN total_orders > 10 THEN 'Regular'                                                                                                                                                                                                                                                                              -- Low volume
  ELSE 'New'                                                                                                                                                                                                                                                                                                         -- First-time customer
  END                                                                                                                                                                                                                                                                                                               as customer_tier
from customer_summary

                                                                                                                                                                                                                                                                                                                     -- Long comment that should wrap
;
select

  id
  ,                                                                                                                                                                                                                                                                                                                  -- This is a very long comment that explains something complex about this column and should wrap
                                                                                                                                                                                                                                                                                                                     -- at
                                                                                                                                                                                                                                                                                                                     -- around
                                                                                                                                                                                                                                                                                                                     -- 100
                                                                                                                                                                                                                                                                                                                     -- characters
                                                                                                                                                                                                                                                                                                                     -- to
                                                                                                                                                                                                                                                                                                                     -- maintain
                                                                                                                                                                                                                                                                                                                     -- readability
  value
from table1

                                                                                                                                                                                                                                                                                                                     -- SQL keywords in strings(should not trigger formatting)
;
select

  '
;
select
  *
from customers
where status = ''active'''                                                                                                                                                                                                                                                                                           as example_query
  ,'This string contains
;
select
  and
from keywords'                                                                                                                                                                                                                                                                                                       as description
  ,'join is also a keyword'                                                                                                                                                                                                                                                                                          as another_example
from dual

                                                                                                                                                                                                                                                                                                                     -- Strings
;
with quotes
select

  name
  ,replace(name, '''', '')                                                                                                                                                                                                                                                                                           as name_without_quotes,
  'Customer''s order'                                                                                                                                                                                                                                                                                                as description
from customers

                                                                                                                                                                                                                                                                                                                     -- Comments containing SQL keywords
                                                                                                                                                                                                                                                                                                                     -- This comment mentions
;
select

,from,
where and
join but should stay as-is
;
select
  *
from orders

                                                                                                                                                                                                                                                                                                                     -- String
;
with newline characters
select

  'Line 1
  Line 2
  Line 3'                                                                                                                                                                                                                                                                                                            as multiline_string
from dual

                                                                                                                                                                                                                                                                                                                     -- Comment at END of line
;
with semicolon
select
  *
from customers;                                                                                                                                                                                                                                                                                                      -- This is the END

                                                                                                                                                                                                                                                                                                                     -- Multiple inline comments
;
select

  col1,                                                                                                                                                                                                                                                                                                              -- First column
  col2,                                                                                                                                                                                                                                                                                                              -- Second column
  col3                                                                                                                                                                                                                                                                                                               -- Third column
from table1

                                                                                                                                                                                                                                                                                                                     -- Comments in subquery
;
select
  *
from(
                                                                                                                                                                                                                                                                                                                     -- This is a subquery
select

  customer_id
  ,count(*)                                                                                                                                                                                                                                                                                                          as order_count      -- Count
                                                                                                                                                                                                                                                                                                                                         -- orders
                                                                                                                                                                                                                                                                                                                                         -- per
                                                                                                                                                                                                                                                                                                                                         -- customer
from orders
group by customer_id
with special characters
  /*
  * Special characters: @#$%^&*()
  * SQL keywords:
select
from
where
  * Code example:
select
  *
from table
  */
select
  *
from customers

                                                                                                                                                                                                                                                                                                                     -- Comment alignment in CASE
select

  order_id
  ,CASE
  WHEN amount > 1000 THEN 'High'                                                                                                                                                                                                                                                                                     -- Large orders
  WHEN amount > 100 THEN 'Medium'                                                                                                                                                                                                                                                                                    -- Medium orders
  ELSE 'Low'                                                                                                                                                                                                                                                                                                         -- Small orders
  END                                                                                                                                                                                                                                                                                                               as order_size
from orders

                                                                                                                                                                                                                                                                                                                     -- Comments in CTE
with
                                                                                                                                                                                                                                                                                                                     -- First CTE - active customers
  active_customers as(
select
  customer_id, name
from customers
where status = 'active'                                                                                                                                                                                                                                                                                              -- Only active accounts
  )
  ,                                                                                                                                                                                                                                                                                                                  -- Second CTE - recent orders
  recent_orders as(
select
  customer_id, order_id, order_date
from orders
where order_date >= '2024-01-01'                                                                                                                                                                                                                                                                                     -- This year only
  )
select

  ac.name
  ,ro.order_id                                                                                                                                                                                                                                                                                                       -- Order reference
from active_customers ac
join recent_orders ro
on ac.customer_id = ro.customer_id

                                                                                                                                                                                                                                                                                                                     -- String concatenation
with quotes
select

  concat('Customer: ', name, ' (', email, ')')                                                                                                                                                                                                                                                                       as customer_info
  ,'Status: ' || status                                                                                                                                                                                                                                                                                              as status_info
from customers

                                                                                                                                                                                                                                                                                                                     -- Comments before semicolon
select
  *
from orders
                                                                                                                                                                                                                                                                                                                     -- This query retrieves all orders

                                                                                                                                                                                                                                                                                                                     -- Comment in CASE statement
  ) subquery

                                                                                                                                                                                                                                                                                                                     -- Block comment


                                                                                                                                                                                                                                                                                                                     -- Comment between statements
;
select
  *
from customers
                                                                                                                                                                                                                                                                                                                     -- Next query
;
select
  *
from orders

                                                                                                                                                                                                                                                                                                                     -- Nested block comments(some databases support)
  /*
  * outer comment
  * /* inner comment */
  * Still in outer
  */
;
select
  *
from products

                                                                                                                                                                                                                                                                                                                     -- Comment
;
with special formatting
                                                                                                                                                                                                                                                                                                                     -- ==========================================
                                                                                                                                                                                                                                                                                                                     -- IMPORTANT QUERY - DO NOT MODIFY
                                                                                                                                                                                                                                                                                                                     -- ==========================================
select
  *
from critical_table

                                                                                                                                                                                                                                                                                                                     -- Inline comment in window function
;
select

  employee_id
  ,salary,
  avg(salary) over(partition by department)                                                                                                                                                                                                                                                                          as dept_avg         -- Department
                                                                                                                                                                                                                                                                                                                                         -- average
from employees

                                                                                                                                                                                                                                                                                                                     -- Comment in aggregate
;
select

  department
  ,sum(salary)                                                                                                                                                                                                                                                                                                       as total_salary,    -- Total
                                                                                                                                                                                                                                                                                                                                         -- department
                                                                                                                                                                                                                                                                                                                                         -- salary
  avg(salary)                                                                                                                                                                                                                                                                                                        as avg_salary,      -- Average
                                                                                                                                                                                                                                                                                                                                         -- department
                                                                                                                                                                                                                                                                                                                                         -- salary
  count(*)                                                                                                                                                                                                                                                                                                           as employee_count    -- Number
                                                                                                                                                                                                                                                                                                                                          -- of
                                                                                                                                                                                                                                                                                                                                          -- employees
from employees
group by department
with escaped characters
select

  'Tab:\t Newline:\n Quote:\" Backslash:\\'                                                                                                                                                                                                                                                                          as escaped_chars
from dual

                                                                                                                                                                                                                                                                                                                     -- Comment
;
with URLs and emails
                                                                                                                                                                                                                                                                                                                     -- For more info: https://example.com/docs
                                                                                                                                                                                                                                                                                                                     -- Contact: support@example.com
select
  *
from help_topics

                                                                                                                                                                                                                                                                                                                     -- Multi-line string in CASE
;
select

  id
  ,CASE
  WHEN type = 'A' THEN 'This is a very long string that describes type A
;
with lots of detail'
  WHEN type = 'B' THEN 'This is a very long string that describes type B
;
with lots of detail'
  ELSE 'Default description'
  END                                                                                                                                                                                                                                                                                                               as description
from items

                                                                                                                                                                                                                                                                                                                     -- Comments in named_struct
select

  id
  ,named_struct(
'name'  , customer_name,                                                                                                                                                                                                                                                                                             -- Customer's full name
'email'  , email,                                                                                                                                                                                                                                                                                                    -- Contact email address
'phone'  , phone                                                                                                                                                                                                                                                                                                     -- Phone number
  )                                                                                                                                                                                                                                                                                                                 as contact_info
from customers

                                                                                                                                                                                                                                                                                                                     -- String
;
