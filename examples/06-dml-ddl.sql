-- =============================================================================
-- 06-dml-ddl.sql
-- Data Manipulation Language (INSERT, UPDATE, DELETE, MERGE) and
-- Data Definition Language (CREATE, ALTER, DROP)
-- =============================================================================

-- Simple INSERT
INSERT INTO customers (customer_id, name, email)
VALUES (1, 'John Doe', 'john@example.com');

-- INSERT multiple rows
INSERT INTO customers (customer_id, name, email)
VALUES 
    (1, 'John Doe', 'john@example.com'),
    (2, 'Jane Smith', 'jane@example.com'),
    (3, 'Bob Johnson', 'bob@example.com');

-- INSERT from SELECT
INSERT INTO customer_summary
SELECT 
    customer_id,
    COUNT(*) as order_count,
    SUM(order_total) as lifetime_value
FROM orders
GROUP BY customer_id;

-- INSERT OVERWRITE (Spark/Hive)
INSERT OVERWRITE TABLE target_table
SELECT * FROM source_table
WHERE date >= '2024-01-01';

-- INSERT with partition (Spark/Hive)
INSERT INTO TABLE sales PARTITION (year=2024, month=1)
SELECT sale_id, product_id, amount, sale_date
FROM raw_sales
WHERE YEAR(sale_date) = 2024 AND MONTH(sale_date) = 1;

-- Simple UPDATE
UPDATE customers
SET status = 'inactive'
WHERE last_purchase_date < '2023-01-01';

-- UPDATE with multiple columns
UPDATE employees
SET 
    salary = salary * 1.05,
    last_review_date = CURRENT_DATE,
    reviewer_id = 101
WHERE department = 'Engineering'
  AND performance_rating >= 4;

-- UPDATE with CASE
UPDATE products
SET price = CASE 
    WHEN category = 'Electronics' THEN price * 1.10
    WHEN category = 'Clothing' THEN price * 1.05
    ELSE price
END
WHERE last_price_update < '2024-01-01';

-- UPDATE with subquery
UPDATE employees
SET salary = (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department = employees.department
)
WHERE salary IS NULL;

-- UPDATE with JOIN (some SQL dialects)
UPDATE employees e
SET e.manager_name = m.name
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id;

-- Simple DELETE
DELETE FROM customers
WHERE status = 'deleted';

-- DELETE with complex WHERE
DELETE FROM orders
WHERE order_date < DATE_SUB(CURRENT_DATE, 365)
  AND status IN ('cancelled', 'returned')
  AND customer_id NOT IN (SELECT customer_id FROM vip_customers);

-- DELETE with subquery
DELETE FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id
    FROM order_items
    WHERE order_date >= '2023-01-01'
);

-- MERGE statement (Spark 3.0+, Delta Lake)
MERGE INTO target_customers t
USING source_customers s
ON t.customer_id = s.customer_id
WHEN MATCHED THEN
    UPDATE SET 
        t.name = s.name,
        t.email = s.email,
        t.updated_at = CURRENT_TIMESTAMP
WHEN NOT MATCHED THEN
    INSERT (customer_id, name, email, created_at)
    VALUES (s.customer_id, s.name, s.email, CURRENT_TIMESTAMP);

-- MERGE with complex conditions
MERGE INTO inventory i
USING (
    SELECT 
        product_id,
        SUM(quantity) as total_quantity
    FROM daily_shipments
    WHERE shipment_date = CURRENT_DATE
    GROUP BY product_id
) s
ON i.product_id = s.product_id
WHEN MATCHED AND s.total_quantity > 0 THEN
    UPDATE SET 
        i.quantity = i.quantity + s.total_quantity,
        i.last_updated = CURRENT_TIMESTAMP
WHEN MATCHED AND s.total_quantity < 0 THEN
    UPDATE SET 
        i.quantity = i.quantity + s.total_quantity,
        i.last_updated = CURRENT_TIMESTAMP,
        i.needs_reorder = CASE WHEN i.quantity + s.total_quantity < i.reorder_point THEN TRUE ELSE FALSE END
WHEN NOT MATCHED THEN
    INSERT (product_id, quantity, last_updated)
    VALUES (s.product_id, s.total_quantity, CURRENT_TIMESTAMP);

-- MERGE with DELETE
MERGE INTO customers t
USING customer_updates s
ON t.customer_id = s.customer_id
WHEN MATCHED AND s.is_deleted = TRUE THEN
    DELETE
WHEN MATCHED THEN
    UPDATE SET 
        t.name = s.name,
        t.status = s.status
WHEN NOT MATCHED THEN
    INSERT (customer_id, name, status)
    VALUES (s.customer_id, s.name, s.status);

-- CREATE TABLE
CREATE TABLE customers (
    customer_id INT,
    name STRING,
    email STRING,
    created_at TIMESTAMP,
    status STRING
);

-- CREATE TABLE with constraints
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_total DECIMAL(10, 2),
    status STRING DEFAULT 'pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- CREATE TABLE AS SELECT (CTAS)
CREATE TABLE high_value_customers AS
SELECT 
    customer_id,
    name,
    email,
    SUM(order_total) as lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY customer_id, name, email
HAVING SUM(order_total) > 10000;

-- CREATE TABLE with partitioning (Spark/Hive)
CREATE TABLE sales (
    sale_id BIGINT,
    product_id INT,
    amount DECIMAL(10, 2),
    sale_date DATE
)
PARTITIONED BY (year INT, month INT);

-- CREATE TABLE with bucketing (Spark/Hive)
CREATE TABLE user_events (
    user_id BIGINT,
    event_type STRING,
    event_timestamp TIMESTAMP
)
CLUSTERED BY (user_id) INTO 100 BUCKETS;

-- CREATE EXTERNAL TABLE (Spark/Hive)
CREATE EXTERNAL TABLE external_data (
    id INT,
    value STRING
)
LOCATION '/path/to/data';

-- CREATE TABLE with file format (Spark)
CREATE TABLE parquet_table (
    id INT,
    name STRING
)
USING PARQUET
OPTIONS (compression 'snappy');

-- CREATE TEMPORARY VIEW
CREATE TEMPORARY VIEW active_customers AS
SELECT *
FROM customers
WHERE status = 'active';

-- CREATE OR REPLACE VIEW
CREATE OR REPLACE VIEW customer_order_summary AS
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) as order_count,
    SUM(o.order_total) as total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- ALTER TABLE - Add column
ALTER TABLE customers
ADD COLUMN phone STRING;

-- ALTER TABLE - Multiple columns
ALTER TABLE customers
ADD COLUMNS (
    phone STRING,
    address STRING,
    city STRING,
    zip STRING
);

-- ALTER TABLE - Drop column
ALTER TABLE customers
DROP COLUMN temp_column;

-- ALTER TABLE - Rename column
ALTER TABLE customers
RENAME COLUMN old_name TO new_name;

-- ALTER TABLE - Change column type
ALTER TABLE customers
ALTER COLUMN email TYPE VARCHAR(255);

-- ALTER TABLE - Add partition (Hive/Spark)
ALTER TABLE sales
ADD PARTITION (year=2024, month=1)
LOCATION '/data/sales/2024/01';

-- ALTER TABLE - Drop partition
ALTER TABLE sales
DROP PARTITION (year=2023, month=1);

-- ALTER TABLE - Rename table
ALTER TABLE old_table_name
RENAME TO new_table_name;

-- DROP TABLE
DROP TABLE IF EXISTS temp_table;

-- DROP TABLE with CASCADE (some dialects)
DROP TABLE IF EXISTS parent_table CASCADE;

-- DROP VIEW
DROP VIEW IF EXISTS old_view;

-- TRUNCATE TABLE
TRUNCATE TABLE staging_table;

-- TRUNCATE with partition (Spark/Hive)
TRUNCATE TABLE sales PARTITION (year=2023);
