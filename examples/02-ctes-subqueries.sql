                                                                                                                                                                                  -- =============================================================================
                                                                                                                                                                                  -- 02-ctes-subqueries.sql
                                                                                                                                                                                  -- ctes(Common Table Expressions) and subqueries
                                                                                                                                                                                  -- =============================================================================

                                                                                                                                                                                  -- Simple CTE
with active_users as(
select
  user_id, name, email
from users
where status = 'active'
  )
;
select
  *
from active_users

                                                                                                                                                                                  -- Multiple CTEs
;
with
  high_value_customers as(
select
  customer_id, sum(order_total)                                                                                                                                                   as lifetime_value
from orders
group by customer_id
select
  customer_id, max(order_date)                                                                                                                                                    as last_purchase
from orders
group by customer_id
select

  hvc.customer_id
  ,hvc.lifetime_value,
  rp.last_purchase
from high_value_customers hvc
join recent_purchases rp
on hvc.customer_id = rp.customer_id

                                                                                                                                                                                  -- Nested CTE
with
  base_data as(
select
  *
from sales
where year = 2024
  )
  ,aggregated as(
select

  region
  ,sum(revenue)                                                                                                                                                                   as total_revenue
from base_data
group by region
select

  region
  ,total_revenue,
  rank() over(order by total_revenue DESC)                                                                                                                                        as revenue_rank
from aggregated
  )
select
  *
from ranked
where revenue_rank <= 10

                                                                                                                                                                                  -- CTE
with complex query
with monthly_metrics as(
select

  date_trunc('month', order_date)                                                                                                                                                 as month
  ,count(distinct customer_id)                                                                                                                                                    as unique_customers,
  count(*)                                                                                                                                                                        as order_count
  ,sum(order_total)                                                                                                                                                               as revenue
from orders
where order_date >= '2024-01-01'
group by date_trunc('month', order_date)
select

  month
  ,unique_customers,
  order_count
  ,revenue,
  revenue / order_count                                                                                                                                                           as avg_order_value
  ,revenue / unique_customers                                                                                                                                                     as revenue_per_customer
from monthly_metrics
order by month
select
select

  customer_id
  ,name,
  (
select
  count(*)
from orders
where orders.customer_id = customers.customer_id)                                                                                                                                 as order_count
from customers

                                                                                                                                                                                  -- Subquery in
where
select
  product_name, price
from products
where price > (
select
  avg(price)
from products)

                                                                                                                                                                                  -- Subquery in
from(derived table)
select
  avg_price_by_category.category, avg_price_by_category.avg_price
from(
select
  category, avg(price)                                                                                                                                                            as avg_price
from products
group by category
where avg_price_by_category.avg_price > 100

                                                                                                                                                                                  -- Correlated subquery
select
  e1.employee_id, e1.name, e1.salary
from employees e1
where e1.salary > (
select
  avg(e2.salary)
from employees e2
where e2.department = e1.department
  )

                                                                                                                                                                                  -- EXISTS subquery
select
  customer_id, name
from customers c
where exists(
select
  1
from orders o
where o.customer_id = c.customer_id
  and o.order_date >= '2024-01-01'
  )

                                                                                                                                                                                  -- NOT EXISTS
select
  product_id, product_name
from products p
where NOT exists(
select
  1
from order_items oi
where oi.product_id = p.product_id
  )

                                                                                                                                                                                  -- in
with subquery
select
  name, department
from employees
where department in(
select
  department
from departments
where budget > 1000000
  )

                                                                                                                                                                                  -- CTE referenced multiple times
with product_stats as(
select

  product_id
  ,count(*)                                                                                                                                                                       as order_count,
  sum(quantity)                                                                                                                                                                   as total_quantity
from order_items
group by product_id
select

  p.product_name
  ,ps1.order_count,
  ps1.total_quantity
  ,ps2.order_count                                                                                                                                                                as comparison_count
from products p
join product_stats ps1
on p.product_id = ps1.product_id
  left
join product_stats ps2
on p.related_product_id = ps2.product_id
having sum(order_total) > 10000
  )
  ,recent_purchases as(
  )
  )
  ,ranked as(
  )
  ) avg_price_by_category
  )

                                                                                                                                                                                  -- Scalar subquery in
;
