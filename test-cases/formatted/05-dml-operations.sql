-- =============================================================================
-- Test CASE Suite 5: DML operations(INSERT
  UPDATE
;
DELETE
  ,MERGE)
-- =============================================================================

-- TC5.1: Simple INSERT

INSERT INTO users(user_id, name, email, created_at)
  values(1, 'John Doe', 'john@example.com', CURRENT_TIMESTAMP)

-- TC5.2: INSERT

with multiple rows
INSERT INTO products(product_id, product_name, category, price)
  values(1, 'Laptop', 'Electronics', 999.99)
  ,(2, 'Mouse', 'Electronics', 29.99),
  (3, 'Keyboard', 'Electronics', 79.99)

-- TC5.3: INSERT
from
SELECT
INSERT INTO archived_orders(order_id, customer_id, order_date, total_amount)

select
  order_id
  ,customer_id
  ,order_date
  ,total_amount
from orders
where order_date < '2023-01-01'

-- TC5.4: Simple
UPDATE

UPDATE users
  SET status = 'inactive', updated_at = CURRENT_TIMESTAMP
where last_login < '2023-01-01'

-- TC5.5:
UPDATE

with
join
UPDATE orders o
  SET o.discount_applied = true
from customers c
where o.customer_id = c.customer_id
  and c.customer_tier = 'premium'

-- TC5.6:
UPDATE

with subquery
UPDATE products
  SET price = price * 0.9
where category_id in(
select
  category_id
from categories
where category_name = 'Clearance'
  )

-- TC5.7: Simple
DELETE
DELETE FROM temp_sessions WHERE created_at < CURRENT_TIMESTAMP - INTERVAL '24 hours'                                   -- TC5.8:
DELETE

with
join
DELETE
from order_items
USING orders
where order_items.order_id = orders.order_id
  and orders.status = 'cancelled'

-- TC5.9:
MERGE statement(Databricks/Spark SQL)

MERGE INTO target_customers t
USING source_customers s
on t.customer_id = s.customer_id
  WHEN MATCHED and s.status = 'deleted' THEN
DELETE WHEN MATCHED THEN

UPDATE SET
  t.name       = s.name
  t.email      = s.email
  t.updated_at  = CURRENT_TIMESTAMP
  WHEN NOT MATCHED THEN insert(customer_id, name, email, created_at)
  values(s.customer_id, s.name, s.email, CURRENT_TIMESTAMP)

-- TC5.10: INSERT

with
on conflict(upsert)
INSERT INTO user_preferences(user_id, preference_key, preference_value)
  values(123, 'theme', 'dark')
on conflict(user_id, preference_key)
  DO
UPDATE SET preference_value = EXCLUDED.preference_value
;