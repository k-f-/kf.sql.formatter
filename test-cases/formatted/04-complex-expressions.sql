-- =============================================================================
-- Test CASE Suite 4: Complex Expressions
-- =============================================================================

-- TC4.1: Simple CASE statement

select
  employee_id
  name
  salary
  ,CASE
  WHEN salary >= 100000 THEN 'High'
  WHEN salary >= 60000 THEN 'Medium'
  ELSE 'Low'
  END                                                                                                                                                                                                                                        as salary_category
from employees

-- TC4.2: CASE

;
with multiple conditions
select
  order_id
  status
  total_amount
  ,CASE
  WHEN status = 'completed' and total_amount > 1000 THEN 'Premium Completed'
  WHEN status = 'completed' THEN 'Standard Completed'
  WHEN status = 'pending' and total_amount > 1000 THEN 'Premium Pending'
  WHEN status = 'pending' THEN 'Standard Pending'
  ELSE 'Other'
  END                                                                                                                                                                                                                                        as order_classification
from orders

-- TC4.3: Window function - ROW_NUMBER

;
select
  employee_id
  name
  department_id
  salary
  row_number() over(PARTITION BY department_id
order by salary DESC)                                                                                                                                                                                                                         as salary_rank
from employees

-- TC4.4: Window function - RANK and DENSE_RANK

;
select
  product_id
  product_name
  category_id
  price
  rank() over(PARTITION BY category_id
order by price DESC)                                                                                                                                                                                                                          as price_rank
order by price DESC)                                                                                                                                                                                                                          as dense_price_rank
from products

-- TC4.5: Window function - Aggregate functions
select
  order_id
  order_date
  amount
  ,sum(amount) over(order by order_date)                                                                                                                                                                                                      as running_total,
  avg(amount) over(
order by order_date
from orders

-- TC4.6: Window function - LEAD and LAG

;
select
  sale_date
  amount
  lag(amount, 1) over(order by sale_date)                                                                                                                                                                                                     as previous_day_amount
  ,lead(amount, 1) over(order by sale_date)                                                                                                                                                                                                   as next_day_amount
from daily_sales

-- TC4.7: Nested functions

;
select
  user_id
  ,upper(trim(substring(email, 1, position('@' in email) - 1)))                                                                                                                                                                               as username,
  lower(substring(email, position('@' in email) + 1))                                                                                                                                                                                         as domain
from users

-- TC4.8: COALESCE and NULLIF

;
select
  customer_id
  ,coalesce(phone_number, mobile_number, 'No contact')                                                                                                                                                                                        as contact_number,
  nullif(email, '')                                                                                                                                                                                                                           as valid_email
from customers

-- TC4.9: String concatenation

;
select
  first_name
  last_name
  first_name || ' ' || last_name                                                                                                                                                                                                              as full_name
  ,concat(first_name, ' ', last_name)                                                                                                                                                                                                         as full_name_concat
from employees

-- TC4.10: Date functions

select
  order_id
  order_date
  extract(YEAR
from order_date)                                                                                                                                                                                                                              as order_year
  ,extract(MONTH
from order_date)                                                                                                                                                                                                                              as order_month
  ,date_trunc('month', order_date)                                                                                                                                                                                                            as month_start,
  order_date + INTERVAL '30 days'                                                                                                                                                                                                             as estimated_delivery
from orders
  ,dense_rank() over(PARTITION BY category_id
  ROWS BETWEEN 6 PRECEDING and CURRENT ROW)                                                                                                                                                                                                   as moving_avg_7day
;