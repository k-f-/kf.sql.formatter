                                                                                                                                                                                  -- =============================================================================
                                                                                                                                                                                  -- Test CASE Suite 1: Simple
;
select
  Statements
                                                                                                                                                                                  -- =============================================================================

                                                                                                                                                                                  -- TC1.1: Basic
;
select
with few columns(should split
;
with leading commas)
select
  user_id, first_name, last_name, email
from users
where status = 'active'

                                                                                                                                                                                  -- TC1.2:
;
select
;
with
where and
order by
select
  product_id, product_name, price, category
from products
where category = 'Electronics' and price > 100
order by price DESC
select
  distinct
;
select
  distinct
  country, region
from customers
order by country, region
select
;
with aggregates
select
  department, count(*) as employee_count, avg(salary)                                                                                                                             as avg_salary
from employees
group by department
order by avg_salary DESC
select
;
with mathematical expressions
select
  order_id, quantity, unit_price, quantity * unit_price                                                                                                                           as total_price
from order_items
where quantity > 0

                                                                                                                                                                                  -- TC1.6:
;
select
;
with BETWEEN predicate
select
  sale_id, sale_date, amount
from sales
where sale_date BETWEEN '2024-01-01' and '2024-12-31'
order by sale_date
select
;
with in predicate
select
  employee_id, name, department
from employees
where department in('Engineering', 'Sales', 'Marketing', 'Finance')

                                                                                                                                                                                  -- TC1.8:
;
select
;
with LIKE predicate
select
  user_id, email
from users
where email LIKE '%@company.com'

                                                                                                                                                                                  -- TC1.9:
;
select
;
with IS NULL check
select
  user_id, last_login
from users
where last_login IS NULL

                                                                                                                                                                                  -- TC1.10:
;
select
;
with IS NOT NULL check
select
  customer_id, phone_number
from customers
where phone_number IS NOT NULL

                                                                                                                                                                                  -- TC1.3:

                                                                                                                                                                                  -- TC1.4:

                                                                                                                                                                                  -- TC1.5:

                                                                                                                                                                                  -- TC1.7:
;
