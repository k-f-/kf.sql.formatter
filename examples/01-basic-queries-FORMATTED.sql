  -- =============================================================================
  -- 01-basic-queries.sql
  -- Simple

select
  statements to test basic formatting
  -- =============================================================================

  -- Single table, simple
where
;
SELECT
  id
  ,name
  ,email FROM users WHERE status = 'active'                                                                                                                                                                                           -- Multiple columns
  ,ORDER BY

;
select
  user_id
  first_name
  last_name
  ,created_at
from customers
where country = 'US'
order by created_at DESC
group by

;
with aggregate
select
  department
  ,count(*)                                                                                                                                                                                                                           as employee_count,
  avg(salary)                                                                                                                                                                                                                         as avg_salary
from employees
group by department
order by avg_salary DESC
where

;
select
  product_id
  ,product_name
  ,price
from products
where category = 'Electronics'
  and price > 100

  -- distinct

;
select  distinct
  country
from customers
order by country
;
select
  *
from orders
order by order_date DESC
;
SELECT

;
select
  order_id
  quantity
  unit_price
  ,quantity * unit_price                                                                                                                                                                                                              as total_price
from order_items

  -- BETWEEN predicate
;
SELECT * FROM sales WHERE sale_date BETWEEN '2024-01-01' and '2024-12-31'                                                                                                                                                             -- in predicate

;
select
  name
  ,department
from employees
where department in('Engineering', 'Sales', 'Marketing')

  -- LIKE predicate
;
SELECT email FROM users WHERE email LIKE '%@example.com'                                                                                                                                                                              -- IS NULL / IS NOT NULL
;
SELECT
  user_id
  ,last_login FROM users WHERE last_login IS NULL                                                                                                                                                                                     -- HAVING clause
;
SELECT
  category
  ,count(*) AS product_count FROM products GROUP BY category

;
select
  region
  ,sum(revenue)                                                                                                                                                                                                                       as total_revenue,
  avg(revenue)                                                                                                                                                                                                                        as avg_revenue
  ,min(revenue)                                                                                                                                                                                                                       as min_revenue,
  max(revenue)                                                                                                                                                                                                                        as max_revenue
  ,count(*)                                                                                                                                                                                                                           as sale_count
from sales
group by region
select
  *
from simple_table
where id = 1
having count(*) > 5

  -- Multiple aggregates

  -- Short query(should stay
on one line if ≤100 chars)

  -- Multiple predicates in
limit
limit 10

  -- Simple math in
  and in_stock = true
;