-- =============================================================================
-- 01-basic-queries.sql
-- Simple SELECT statements to test basic formatting
-- =============================================================================

-- Single table, simple WHERE
SELECT id, name, email
FROM users
WHERE status = 'active';

-- Multiple columns, ORDER BY
SELECT 
    user_id,
    first_name,
    last_name,
    created_at
FROM customers
WHERE country = 'US'
ORDER BY created_at DESC;

-- GROUP BY with aggregate
SELECT 
    department,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;

-- Multiple predicates in WHERE
SELECT product_id, product_name, price
FROM products
WHERE category = 'Electronics'
  AND price > 100
  AND in_stock = true;

-- DISTINCT
SELECT DISTINCT country
FROM customers
ORDER BY country;

-- LIMIT
SELECT *
FROM orders
ORDER BY order_date DESC
LIMIT 10;

-- Simple math in SELECT
SELECT 
    order_id,
    quantity,
    unit_price,
    quantity * unit_price as total_price
FROM order_items;

-- BETWEEN predicate
SELECT *
FROM sales
WHERE sale_date BETWEEN '2024-01-01' AND '2024-12-31';

-- IN predicate
SELECT name, department
FROM employees
WHERE department IN ('Engineering', 'Sales', 'Marketing');

-- LIKE predicate
SELECT email
FROM users
WHERE email LIKE '%@example.com';

-- IS NULL / IS NOT NULL
SELECT user_id, last_login
FROM users
WHERE last_login IS NULL;

-- HAVING clause
SELECT 
    category,
    COUNT(*) as product_count
FROM products
GROUP BY category
HAVING COUNT(*) > 5;

-- Multiple aggregates
SELECT 
    region,
    SUM(revenue) as total_revenue,
    AVG(revenue) as avg_revenue,
    MIN(revenue) as min_revenue,
    MAX(revenue) as max_revenue,
    COUNT(*) as sale_count
FROM sales
GROUP BY region;

-- Short query (should stay on one line if ≤100 chars)
SELECT * FROM simple_table WHERE id = 1;
