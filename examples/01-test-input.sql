                                                                                                                               -- Test CASE 1: Basic
;
select
;
with multiple columns
select
  user_id, first_name, last_name, email, created_at
from customers
where country = 'US' and status = 'active'
order by created_at DESC
with
group by
select
  department, count(*) as employee_count, avg(salary)                                                                          as avg_salary
from employees
group by department
order by avg_salary DESC
select
  distinct
  country
from customers
order by country
select
  order_id, quantity, unit_price, quantity * unit_price                                                                        as total_price
from order_items

                                                                                                                               -- Test CASE 5: BETWEEN predicate
;
select
  *
from sales
where sale_date BETWEEN '2024-01-01' and '2024-12-31'

                                                                                                                               -- Test CASE 6: in predicate
;
select
  name, department
from employees
where department in('Engineering', 'Sales', 'Marketing')

                                                                                                                               -- Test CASE 7: LIKE predicate
;
select
  email
from users
where email LIKE '%@example.com'

                                                                                                                               -- Test CASE 8: IS NULL check
;
select
  user_id, last_login
from users
where last_login IS NULL

                                                                                                                               -- Test CASE 2: Aggregate query

                                                                                                                               -- Test CASE 3: distinct query

                                                                                                                               -- Test CASE 4: Simple math calculation
;
