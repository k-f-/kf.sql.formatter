                                                                                                                                                                                  -- =============================================================================
                                                                                                                                                                                  -- Test CASE Suite 2: JOINs
                                                                                                                                                                                  -- =============================================================================

                                                                                                                                                                                  -- TC2.1: Simple
  inner
join
;
select
  u.user_id, u.name, o.order_id, o.order_date
from users u
  inner
join orders o
on u.user_id = o.user_id
where o.status = 'completed'

                                                                                                                                                                                  -- TC2.2:
  left
join
;
with multiple conditions
select
  c.customer_id, c.name, o.order_id, o.total_amount
from customers c
  left
join orders o
on c.customer_id = o.customer_id and o.order_date >= '2024-01-01'
order by c.customer_id
select

  u.user_id
  ,u.name,
  o.order_id
  ,p.product_name,
  oi.quantity
from users u
  inner
join orders o
on u.user_id = o.user_id
  inner
join order_items oi
on o.order_id = oi.order_id
  inner
join products p
on oi.product_id = p.product_id
where o.order_date >= '2024-01-01'

                                                                                                                                                                                  -- TC2.4:
  right
join
;
select
  d.department_name, e.employee_id, e.name
from departments d
  right
join employees e
on d.department_id = e.department_id

                                                                                                                                                                                  -- TC2.5: full
  outer
join
;
select
  c.customer_id, c.name, o.order_id
from customers c
  full
  outer
join orders o
on c.customer_id = o.customer_id

                                                                                                                                                                                  -- TC2.6:
  cross
join
;
select
  p.product_id, s.store_id
from products p
  cross
join stores s
where p.category = 'Electronics'

                                                                                                                                                                                  -- TC2.7:
join
;
with
using clause
select
  u.user_id, u.name, o.order_id
from users u
  inner
join orders o
using(user_id)
where o.status = 'pending'

                                                                                                                                                                                  -- TC2.8: Self
join
;
select
  e1.employee_id, e1.name as employee_name, e2.name                                                                                                                               as manager_name
from employees e1
  left
join employees e2
on e1.manager_id = e2.employee_id

                                                                                                                                                                                  -- TC2.3: Multiple JOINs
;
