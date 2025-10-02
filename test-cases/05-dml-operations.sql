                                                                                                                                                                                  -- =============================================================================
                                                                                                                                                                                  -- Test CASE Suite 5: DML operations(INSERT
,update,
delete
,merge)
                                                                                                                                                                                  -- =============================================================================

                                                                                                                                                                                  -- TC5.1: Simple INSERT
;
insert into users(user_id, name, email, created_at)
  values(1, 'John Doe', 'john@example.com', CURRENT_TIMESTAMP)

                                                                                                                                                                                  -- TC5.2: INSERT
;
with multiple rows
insert into products(product_id, product_name, category, price)
  values(1, 'Laptop', 'Electronics', 999.99)
  ,(2, 'Mouse', 'Electronics', 29.99),
  (3, 'Keyboard', 'Electronics', 79.99)

                                                                                                                                                                                  -- TC5.3: INSERT
from
;
select
;
insert into archived_orders(order_id, customer_id, order_date, total_amount)
;
select
  order_id, customer_id, order_date, total_amount
from orders
where order_date < '2023-01-01'

                                                                                                                                                                                  -- TC5.4: Simple
;
update
;
update users
  SET status = 'inactive', updated_at = CURRENT_TIMESTAMP
where last_login < '2023-01-01'

                                                                                                                                                                                  -- TC5.5:
;
update
;
with
join
update orders o
  SET o.discount_applied = true
from customers c
where o.customer_id = c.customer_id
  and c.customer_tier = 'premium'

                                                                                                                                                                                  -- TC5.6:
;
update
;
with subquery
update products
  SET price = price * 0.9
where category_id in(
select
  category_id
from categories
where category_name = 'Clearance'
  )

                                                                                                                                                                                  -- TC5.7: Simple
;
delete
;
delete
from temp_sessions
where created_at < CURRENT_TIMESTAMP - INTERVAL '24 hours'

                                                                                                                                                                                  -- TC5.8:
;
delete
;
with
join
delete
from order_items
using orders
where order_items.order_id = orders.order_id
  and orders.status = 'cancelled'

                                                                                                                                                                                  -- TC5.9:
;
merge statement(Databricks/Spark SQL)
;
merge into target_customers t
using source_customers s
on t.customer_id = s.customer_id
  WHEN MATCHED and s.status = 'deleted' THEN
;
delete
  WHEN MATCHED THEN
;
update SET
  t.name       = s.name
  ,t.email     = s.email,
  t.updated_at  = CURRENT_TIMESTAMP
  WHEN NOT MATCHED THEN insert(customer_id, name, email, created_at)
  values(s.customer_id, s.name, s.email, CURRENT_TIMESTAMP)

                                                                                                                                                                                  -- TC5.10: INSERT
;
with
on conflict(upsert)
insert into user_preferences(user_id, preference_key, preference_value)
  values(123, 'theme', 'dark')
on conflict(user_id, preference_key)
  DO
;
update SET preference_value = EXCLUDED.preference_value
