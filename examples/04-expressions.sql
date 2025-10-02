                                                                                                                                                                                  -- =============================================================================
                                                                                                                                                                                  -- 04-expressions.sql
                                                                                                                                                                                  -- Complex expressions: CASE, window functions, nested functions
                                                                                                                                                                                  -- =============================================================================

                                                                                                                                                                                  -- Simple CASE statement
;
select

  employee_id
  ,name,
  CASE
  WHEN salary > 100000 THEN 'High'
  WHEN salary > 50000 THEN 'Medium'
  ELSE 'Low'
  END                                                                                                                                                                            as salary_tier
from employees

                                                                                                                                                                                  -- CASE
;
with multiple conditions in WHEN
select

  order_id
  ,CASE
  WHEN status = 'shipped' and delivery_date < expected_date THEN 'Early'
  WHEN status = 'shipped' and delivery_date = expected_date THEN 'on Time'
  WHEN status = 'shipped' and delivery_date > expected_date THEN 'Late'
  WHEN status = 'pending' THEN 'Not Shipped'
  ELSE 'Unknown'
  END                                                                                                                                                                            as delivery_status
from orders

                                                                                                                                                                                  -- Nested CASE statements
;
select

  customer_id
  ,CASE
  WHEN country = 'US' THEN
  CASE
  WHEN state in('CA', 'NY', 'TX') THEN 'Major State'
  ELSE 'Other State'
  END
  WHEN country in('UK', 'FR', 'DE') THEN 'Europe'
  ELSE 'Other Country'
  END                                                                                                                                                                            as location_category
from customers

                                                                                                                                                                                  -- CASE in aggregate
;
select

  department
  ,count(*)                                                                                                                                                                       as total_employees,
  sum(CASE
         WHEN gender = 'F' THEN 1
         ELSE 0
       END)                                                                                                                                                                       as female_count
  ,sum(CASE
         WHEN gender = 'M' THEN 1
         ELSE 0
       END)                                                                                                                                                                       as male_count
from employees
group by department
select

  order_id
  ,CASE status
  WHEN 'P' THEN 'Pending'
  WHEN 'S' THEN 'Shipped'
  WHEN 'D' THEN 'Delivered'
  WHEN 'C' THEN 'Cancelled'
  ELSE 'Unknown'
  END                                                                                                                                                                            as status_description
from orders

                                                                                                                                                                                  -- Window function: ROW_NUMBER
;
select

  employee_id
  ,name,
  department
  ,salary,
  row_number() over(partition by department
order by salary DESC)                                                                                                                                                             as salary_rank
from employees

                                                                                                                                                                                  -- Window function: RANK and DENSE_RANK
;
select

  product_id
  ,product_name,
  sales
  ,rank() over(order by sales DESC)                                                                                                                                               as sales_rank,
  dense_rank() over(order by sales DESC)                                                                                                                                          as dense_rank
from products

                                                                                                                                                                                  -- Window function
;
with frame specification
select

  date
  ,revenue,
  avg(revenue) over(
order by date
from daily_sales

                                                                                                                                                                                  -- Multiple window functions
select

  employee_id
  ,department,
  salary
  ,avg(salary) over(partition by department)                                                                                                                                      as dept_avg_salary,
  max(salary) over(partition by department)                                                                                                                                       as dept_max_salary
  ,min(salary) over(partition by department)                                                                                                                                      as dept_min_salary,
  salary - avg(salary) over(partition by department)                                                                                                                              as salary_diff_from_avg
from employees

                                                                                                                                                                                  -- LAG and LEAD window functions
select

  date
  ,revenue,
  lag(revenue, 1) over(order by date)                                                                                                                                             as prev_day_revenue
  ,lead(revenue, 1) over(order by date)                                                                                                                                           as next_day_revenue,
  revenue - lag(revenue, 1) over(order by date)                                                                                                                                   as day_over_day_change
from daily_sales

                                                                                                                                                                                  -- NTILE for quartiles
select

  customer_id
  ,total_purchases,
  ntile(4) over(order by total_purchases DESC)                                                                                                                                    as purchase_quartile
from customer_summary

                                                                                                                                                                                  -- Window function
with complex partition by
select

  sale_id
  ,region,
  product_category
  ,sale_amount,
  sum(sale_amount) over(
  partition by region, product_category
order by sale_date
from sales

                                                                                                                                                                                  -- FIRST_VALUE and LAST_VALUE
select

  employee_id
  ,department,
  hire_date
  ,first_value(employee_id) over(
  partition by department
order by hire_date
order by hire_date
from employees

                                                                                                                                                                                  -- Nested function calls
select

  customer_id
  ,upper(trim(substring(email, 1, position('@' in email) - 1)))                                                                                                                   as username
from customers

                                                                                                                                                                                  -- Complex arithmetic expressions
select

  product_id
  ,(price * 1.15) * (1 - discount_pct / 100)                                                                                                                                      as final_price_with_tax,
  round((quantity * price * (1 - discount_pct / 100)), 2)                                                                                                                         as total_after_discount
from order_items

                                                                                                                                                                                  -- String functions nested
select

  concat(
  upper(substring(first_name, 1, 1))
  ,lower(substring(first_name, 2)),
  ' '
  ,upper(substring(last_name, 1, 1)),
  lower(substring(last_name, 2))
  )                                                                                                                                                                              as formatted_name
from employees

                                                                                                                                                                                  -- Date functions
select

  order_id
  ,order_date,
  date_add(order_date, INTERVAL 30 DAY)                                                                                                                                           as expected_delivery
  ,datediff(CURRENT_DATE, order_date)                                                                                                                                             as days_since_order,
  extract(YEAR
from order_date)                                                                                                                                                                  as order_year
  ,extract(MONTH
from order_date)                                                                                                                                                                  as order_month
from orders

                                                                                                                                                                                  -- COALESCE and NULLIF
select

  customer_id
  ,coalesce(phone_mobile, phone_home, phone_work, 'No phone')                                                                                                                     as contact_phone,
  nullif(discount_code, '')                                                                                                                                                       as valid_discount_code
from customers

                                                                                                                                                                                  -- Array/Map functions(Spark specific - will add more in 05-spark-specific)
select

  id
  ,array(col1, col2, col3)                                                                                                                                                        as value_array,
  size(array(col1, col2, col3))                                                                                                                                                   as array_size
from source_table

                                                                                                                                                                                  -- Complex CASE
with window function
select

  employee_id
  ,salary,
  department
  ,CASE
  WHEN salary > avg(salary) over(partition by department) THEN 'Above Average'
  WHEN salary = avg(salary) over(partition by department) THEN 'Average'
  ELSE 'Below Average'
  END                                                                                                                                                                            as salary_category
from employees

                                                                                                                                                                                  -- CASE inside window function
select

  sale_id
  ,product_type,
  sum(CASE
         WHEN status = 'completed' THEN amount
         ELSE 0
       END)
  over(partition by product_type
order by sale_date)                                                                                                                                                               as cumulative_completed_sales
from sales

                                                                                                                                                                                  -- Simple CASE(value-based)
  rows between 6 PRECEDING and current row
  )                                                                                                                                                                              as moving_avg_7day
  )                                                                                                                                                                              as cumulative_sales
  )                                                                                                                                                                              as first_hire_in_dept
  ,last_value(employee_id) over(
  partition by department
  rows between unbounded preceding and UNBOUNDED FOLLOWING
  )                                                                                                                                                                              as last_hire_in_dept
;
