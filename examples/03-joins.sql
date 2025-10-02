                                                                                                                                                                                  -- =============================================================================
                                                                                                                                                                                  -- 03-joins.sql
                                                                                                                                                                                  -- all types of
join operations
                                                                                                                                                                                  -- =============================================================================

                                                                                                                                                                                  -- Simple
  inner
join
;
select

  o.order_id
  ,o.order_date,
  c.customer_name
from orders o
  inner
join customers c
on o.customer_id = c.customer_id

                                                                                                                                                                                  --
  left
join
;
select

  c.customer_id
  ,c.customer_name,
  o.order_id
from customers c
  left
join orders o
on c.customer_id = o.customer_id

                                                                                                                                                                                  --
  right
join
;
select

  o.order_id
  ,c.customer_name
from orders o
  right
join customers c
on o.customer_id = c.customer_id

                                                                                                                                                                                  -- full
  outer
join
;
select

  c.customer_id
  ,c.customer_name,
  o.order_id
from customers c
  full
  outer
join orders o
on c.customer_id = o.customer_id

                                                                                                                                                                                  -- Multiple JOINs
;
select

  o.order_id
  ,c.customer_name,
  p.product_name
  ,oi.quantity
from orders o
join customers c
on o.customer_id = c.customer_id
join order_items oi
on o.order_id = oi.order_id
join products p
on oi.product_id = p.product_id

                                                                                                                                                                                  --
join
;
with multiple conditions
select

  e1.employee_name
  ,e2.manager_name
from employees e1
join employees e2
on e1.manager_id = e2.employee_id
  and e1.department = e2.department

                                                                                                                                                                                  --
join
;
with complex
on clause
select

  s.sale_id
  ,c.customer_name,
  p.product_name
from sales s
join customers c
on s.customer_id = c.customer_id
  and s.sale_date >= c.registration_date
join products p
on s.product_id = p.product_id
  and p.category = 'Electronics'

                                                                                                                                                                                  -- Self-join
;
select

  e1.employee_name                                                                                                                                                                as employee
  ,e2.employee_name                                                                                                                                                               as manager
from employees e1
  left
join employees e2
on e1.manager_id = e2.employee_id

                                                                                                                                                                                  --
  cross
join
;
select

  c.color
  ,s.size
from colors c
  cross
join sizes s

                                                                                                                                                                                  --
join
;
with
using clause(1 column - should inline)
select
  order_id, customer_name
from orders
join customers
using(customer_id)

                                                                                                                                                                                  --
join
;
with
using clause(2+ columns - should break to multi-line)
select
  *
from table1
join table2
using(id, department, location)

                                                                                                                                                                                  --
join
;
with
where filter
select

  o.order_id
  ,c.customer_name,
  o.order_total
from orders o
join customers c
on o.customer_id = c.customer_id
where o.order_date >= '2024-01-01'
  and c.country = 'US'

                                                                                                                                                                                  -- Multiple left JOINs
;
select

  c.customer_id
  ,c.customer_name,
  o.order_id
  ,s.shipment_id,
  p.payment_id
from customers c
  left
join orders o
on c.customer_id = o.customer_id
  left
join shipments s
on o.order_id = s.order_id
  left
join payments p
on o.order_id = p.order_id

                                                                                                                                                                                  -- Mixed
join types
;
select

  e.employee_name
  ,d.department_name,
  p.project_name
from employees e
  inner
join departments d
on e.department_id = d.department_id
  left
join employee_projects ep
on e.employee_id = ep.employee_id
  left
join projects p
on ep.project_id = p.project_id

                                                                                                                                                                                  --
join
;
with subquery
select

  c.customer_name
  ,summary.order_count,
  summary.total_spent
from customers c
join(
select

  customer_id
  ,count(*)                                                                                                                                                                       as order_count,
  sum(order_total)                                                                                                                                                                as total_spent
from orders
group by customer_id
with CTE
with top_customers as(
select
  customer_id, sum(order_total)                                                                                                                                                   as lifetime_value
from orders
group by customer_id
order by lifetime_value DESC
select

  c.customer_name
  ,c.email,
  tc.lifetime_value
from customers c
join top_customers tc
on c.customer_id = tc.customer_id

                                                                                                                                                                                  -- NATURAL
join(Spark/Databricks specific)
select
  *
from table1
  NATURAL
join table2

                                                                                                                                                                                  --
  LATERAL view(Spark specific)
select
  id, exploded_col
from source_table
  LATERAL VIEW explode(array_column) t                                                                                                                                            as exploded_col

                                                                                                                                                                                  -- Short
join(should inline if ≤100 chars)
select
  *
from orders o
join customers c
on o.customer_id = c.customer_id
  ) summary
on c.customer_id = summary.customer_id


join
limit 100
  )
;
