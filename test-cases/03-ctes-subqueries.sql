                                                                                                                                                                                  -- =============================================================================
                                                                                                                                                                                  -- Test CASE Suite 3: CTEs
              and Subqueries
                                                                                                                                                                                  -- =============================================================================

                                                                                                                                                                                  -- TC3.1: Simple CTE
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
order by name
with
  high_value_customers as(
select
  customer_id, sum(amount)                                                                                                                                                        as total_spent
from orders
group by customer_id
select
  customer_id, order_id, order_date
from orders
where order_date >= '2024-01-01'
  )
select
  h.customer_id, h.total_spent, count(r.order_id)                                                                                                                                 as recent_order_count
from high_value_customers h
  left
join recent_orders r
on h.customer_id = r.customer_id
group by h.customer_id, h.total_spent
with RECURSIVE employee_hierarchy as(
select
  employee_id, name, manager_id, 1                                                                                                                                                as level
from employees
where manager_id IS NULL
union all
select
  e.employee_id, e.name, e.manager_id, eh.level + 1
from employees e
  inner
join employee_hierarchy eh
on e.manager_id = eh.employee_id
  )
;
select
  *
from employee_hierarchy
order by level, name
select
;
select

  department_id
  ,department_name,
  (
select
  count(*)
from employees e
where e.department_id = d.department_id)                                                                                                                                          as employee_count
from departments d

                                                                                                                                                                                  -- TC3.5: Subquery in
where(in)
;
select
  product_id, product_name, price
from products
where category_id in(
select
  category_id
from categories
where category_name in('Electronics', 'Computers')
  )

                                                                                                                                                                                  -- TC3.6: Subquery in
where(EXISTS)
;
select
  c.customer_id, c.name
from customers c
where exists(
select
  1
from orders o
where o.customer_id = c.customer_id
  and o.order_date >= '2024-01-01'
  )

                                                                                                                                                                                  -- TC3.7: Correlated subquery
;
select

  p.product_id
  ,p.product_name,
  p.price
  ,(
select
  avg(price)
from products p2
where p2.category_id = p.category_id)                                                                                                                                             as avg_category_price
from products p
where p.price > (
select
  avg(price)
from products p3
where p3.category_id = p.category_id
  )

                                                                                                                                                                                  -- TC3.8: Derived table in
from
;
select
  dept_stats.department_id, dept_stats.avg_salary
from(
select
  department_id, avg(salary) as avg_salary, count(*)                                                                                                                              as employee_count
from employees
group by department_id
where dept_stats.employee_count > 5
having sum(amount) > 10000
  )
  ,recent_orders as(

                                                                                                                                                                                  -- TC3.3: Recursive CTE
  ) dept_stats

                                                                                                                                                                                  -- TC3.2: Multiple CTEs

                                                                                                                                                                                  -- TC3.4: Subquery in
;
