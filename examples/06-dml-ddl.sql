                                                                                                                                                                                  -- =============================================================================
                                                                                                                                                                                  -- 06-dml-ddl.sql
                                                                                                                                                                                  -- Data Manipulation language(INSERT
,update,
delete
,merge) and
                                                                                                                                                                                  -- Data Definition language(create, ALTER, DROP)
                                                                                                                                                                                  -- =============================================================================

                                                                                                                                                                                  -- Simple INSERT
;
insert into customers(customer_id, name, email)
  values(1, 'John Doe', 'john@example.com')

                                                                                                                                                                                  -- INSERT multiple rows
;
insert into customers(customer_id, name, email)
  values(1, 'John Doe', 'john@example.com')
  ,(2, 'Jane Smith', 'jane@example.com'),
  (3, 'Bob Johnson', 'bob@example.com')

                                                                                                                                                                                  -- INSERT
from
;
select
;
insert into customer_summary
;
select

  customer_id
  ,count(*)                                                                                                                                                                       as order_count,
  sum(order_total)                                                                                                                                                                as lifetime_value
from orders
group by customer_id
INSERT OVERWRITE TABLE target_table
;
select
  *
from source_table
where date >= '2024-01-01'

                                                                                                                                                                                  -- INSERT
;
with partition(Spark/Hive)
insert into TABLE sales partition(year=2024, month=1)
;
select
  sale_id, product_id, amount, sale_date
from raw_sales
where year(sale_date) = 2024 and month(sale_date) = 1

                                                                                                                                                                                  -- Simple
;
update
;
update customers
  SET status = 'inactive'
where last_purchase_date < '2023-01-01'

                                                                                                                                                                                  --
;
update
;
with multiple columns
update employees
  SET
  ,last_review_date = CURRENT_DATE,
where department = 'Engineering'
  and performance_rating >= 4

                                                                                                                                                                                  --
;
update
;
with CASE
update products
  SET price = CASE
  WHEN category = 'Electronics' THEN price * 1.10
  WHEN category = 'Clothing' THEN price * 1.05
  ELSE price
  END
where last_price_update < '2024-01-01'

                                                                                                                                                                                  --
;
update
;
with subquery
update employees
  SET salary = (
select
  avg(salary)
from employees e2
where e2.department = employees.department
  )
where salary IS NULL

                                                                                                                                                                                  --
;
update
;
with
join(some SQL dialects)
update employees e
  SET e.manager_name = m.name
from employees e
join employees m
on e.manager_id = m.employee_id

                                                                                                                                                                                  -- Simple
;
delete
;
delete
from customers
where status = 'deleted'

                                                                                                                                                                                  --
;
delete
;
with complex
where
delete
from orders
where order_date < date_sub(CURRENT_DATE, 365)
  and status in('cancelled', 'returned')
  and customer_id NOT in(
select
  customer_id
from vip_customers)

                                                                                                                                                                                  --
;
delete
;
with subquery
delete
from products
where product_id NOT in(
select
  distinct
  product_id
from order_items
where order_date >= '2023-01-01'
  )

                                                                                                                                                                                  --
;
merge statement(Spark 3.0+, Delta Lake)
;
merge into target_customers t
using source_customers s
on t.customer_id = s.customer_id
  WHEN MATCHED THEN
;
update SET
  t.name       = s.name
  ,t.email     = s.email,
  t.updated_at  = CURRENT_TIMESTAMP
  WHEN NOT MATCHED THEN
;
insert(customer_id, name, email, created_at)
  values(s.customer_id, s.name, s.email, CURRENT_TIMESTAMP)

                                                                                                                                                                                  --
;
merge
;
with complex conditions
merge into inventory i
using(
select

  product_id
  ,sum(quantity)                                                                                                                                                                  as total_quantity
from daily_shipments
where shipment_date = CURRENT_DATE
group by product_id
update SET
  i.quantity      = i.quantity + s.total_quantity
  ,i.last_updated  = CURRENT_TIMESTAMP
  WHEN MATCHED and s.total_quantity < 0 THEN
update SET
  i.quantity      = i.quantity + s.total_quantity
  ,i.last_updated  = CURRENT_TIMESTAMP,
  i.needs_reorder  = CASE
         WHEN i.quantity + s.total_quantity < i.reorder_point THEN TRUE
         ELSE FALSE
       END
  WHEN NOT MATCHED THEN
insert(product_id, quantity, last_updated)
  values(s.product_id, s.total_quantity, CURRENT_TIMESTAMP)

                                                                                                                                                                                  --
merge
with
delete
merge into customers t
using customer_updates s
on t.customer_id = s.customer_id
  WHEN MATCHED and s.is_deleted = TRUE THEN
delete
  WHEN MATCHED THEN
update SET
  t.name    = s.name
  ,t.status  = s.status
  WHEN NOT MATCHED THEN
insert(customer_id, name, status)
  values(s.customer_id, s.name, s.status)

                                                                                                                                                                                  --
create TABLE
create TABLE customers(
  customer_id INT
  ,name STRING,
  email STRING
,created_at TIMESTAMP,
  status STRING
  )

                                                                                                                                                                                  --
create TABLE
with constraints
create TABLE orders(
  order_id BIGINT PRIMARY KEY
  ,customer_id INT NOT NULL,
  order_date DATE NOT NULL
  ,order_total decimal(10, 2),
  status STRING DEFAULT 'pending'
  ,FOREIGN key(customer_id) REFERENCES customers(customer_id)
  )

                                                                                                                                                                                  --
create TABLE as
select
  (CTAS)
create TABLE high_value_customers as
select

  customer_id
  ,name,
  email
  ,sum(order_total)                                                                                                                                                               as lifetime_value
from customers c
join orders o
on c.customer_id = o.customer_id
group by customer_id, name, email
with partitioning(Spark/Hive)
create TABLE sales(
  sale_id BIGINT
  ,product_id INT,
  amount decimal(10, 2)
  ,sale_date DATE
  )
  PARTITIONED by(year INT, month INT)

                                                                                                                                                                                  --
create TABLE
with bucketing(Spark/Hive)
create TABLE user_events(
  user_id BIGINT
  ,event_type STRING,
  event_timestamp TIMESTAMP
  )
  CLUSTERED by(user_id) into 100 BUCKETS

                                                                                                                                                                                  --
create EXTERNAL table(Spark/Hive)
create EXTERNAL TABLE external_data(
  id INT
  ,value STRING
  )
  LOCATION '/path/to/data'

                                                                                                                                                                                  --
create TABLE
with file format(Spark)
create TABLE parquet_table(
  id INT
  ,name STRING
  )
using PARQUET
  options(compression 'snappy')

                                                                                                                                                                                  --
create TEMPORARY VIEW
create TEMPORARY VIEW active_customers as
select
  *
from customers
where status = 'active'

                                                                                                                                                                                  --
create or replace VIEW
create or replace VIEW customer_order_summary as
select

  c.customer_id
  ,c.name,
  count(o.order_id)                                                                                                                                                               as order_count
  ,sum(o.order_total)                                                                                                                                                             as total_spent
from customers c
  left
join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.name
with cascade(some dialects)
  DROP TABLE IF EXISTS parent_table CASCADE

                                                                                                                                                                                  -- DROP VIEW
  DROP VIEW IF EXISTS old_view

                                                                                                                                                                                  --
truncate TABLE
truncate TABLE staging_table

                                                                                                                                                                                  --
truncate
with partition(Spark/Hive)
truncate TABLE sales partition(year=2023)
  salary = salary * 1.05
  reviewer_id = 101

                                                                                                                                                                                  -- INSERT overwrite(Spark/Hive)
  ) s
on i.product_id = s.product_id
  WHEN MATCHED and s.total_quantity > 0 THEN
having sum(order_total) > 10000


;
create TABLE

                                                                                                                                                                                  -- ALTER TABLE - Add column
;
  ALTER TABLE customers
  ADD COLUMN phone STRING

                                                                                                                                                                                  -- ALTER TABLE - Multiple columns
;
  ALTER TABLE customers
  ADD columns(
  phone STRING
  ,address STRING,
  city STRING
  ,zip STRING
  )

                                                                                                                                                                                  -- ALTER TABLE - Drop column
;
  ALTER TABLE customers
;
  DROP COLUMN temp_column

                                                                                                                                                                                  -- ALTER TABLE - Rename column
;
  ALTER TABLE customers
  RENAME COLUMN old_name TO new_name

                                                                                                                                                                                  -- ALTER TABLE - Change column type
;
  ALTER TABLE customers
;
  ALTER COLUMN email TYPE varchar(255)

                                                                                                                                                                                  -- ALTER TABLE - Add partition(Hive/Spark)
;
  ALTER TABLE sales
  ADD partition(year=2024, month=1)
  LOCATION '/data/sales/2024/01'

                                                                                                                                                                                  -- ALTER TABLE - Drop partition
;
  ALTER TABLE sales
;
  DROP partition(year=2023, month=1)

                                                                                                                                                                                  -- ALTER TABLE - Rename table
;
  ALTER TABLE old_table_name
  RENAME TO new_table_name

                                                                                                                                                                                  -- DROP TABLE
;
  DROP TABLE IF EXISTS temp_table

                                                                                                                                                                                  -- DROP TABLE
;
