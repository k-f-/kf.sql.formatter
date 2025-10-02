-- =============================================================================
-- Test CASE Suite 1: Simple

select
  Statements
-- =============================================================================

-- TC1.1: Basic
SELECT WITH few columns(should split

;
with leading commas)
select
  user_id
  ,first_name
  ,last_name
  ,email
from users
where status = 'active'

-- TC1.2:
;
SELECT

;
with
where and
order by
select
  product_id
  ,product_name
  ,price
  ,category
from products
where category = 'Electronics' and price > 100
order by price DESC
;
select  distinct
;
SELECT
  DISTINCT country
  ,region FROM customers ORDER BY country
  ,region SELECT

;
with aggregates
select
  department
  ,count(*)                                                                                                                                                                                    as employee_count
  ,avg(salary)                                                                                                                                                                                 as avg_salary
from employees
group by department
order by avg_salary DESC
;
select

;
with mathematical expressions
select
  order_id
  ,quantity
  ,unit_price
  ,quantity * unit_price                                                                                                                                                                       as total_price
from order_items
where quantity > 0

-- TC1.6:
;
SELECT

;
with BETWEEN predicate
select
  sale_id
  ,sale_date
  ,amount
from sales
where sale_date BETWEEN '2024-01-01' and '2024-12-31'
order by sale_date
;
select

;
with in predicate
select
  employee_id
  ,name
  ,department
from employees
where department in('Engineering', 'Sales', 'Marketing', 'Finance')

-- TC1.8:
;
SELECT
;
WITH LIKE predicate SELECT user_id, email FROM users WHERE email LIKE '%@company.com'                                                                                                          -- TC1.9:
SELECT
;
WITH IS NULL check SELECT user_id, last_login FROM users WHERE last_login IS NULL                                                                                                              -- TC1.10:
SELECT

with IS NOT NULL check
select
  customer_id
  ,phone_number
from customers
where phone_number IS NOT NULL

-- TC1.3:

-- TC1.4:

-- TC1.5:

-- TC1.7:
;