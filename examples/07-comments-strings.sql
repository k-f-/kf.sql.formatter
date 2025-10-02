-- =============================================================================
-- 07-comments-strings.sql
-- Testing comment handling and strings containing SQL keywords
-- =============================================================================

-- Single line comment before SELECT
-- This is a comment
SELECT * FROM customers;

-- Comment after SELECT keyword
SELECT -- inline comment
    customer_id,
    name
FROM customers;

-- Inline comments in column list
SELECT 
    customer_id,      -- Primary key
    name,             -- Customer full name
    email,            -- Contact email
    created_at        -- Account creation timestamp
FROM customers;

-- Block comment
/*
 * This is a multi-line
 * block comment
 */
SELECT * FROM orders;

/* Inline block comment */ SELECT * FROM products;

-- Comments in WHERE clause
SELECT *
FROM orders
WHERE status = 'active'    -- Only active orders
  AND order_date >= '2024-01-01'  -- From this year
  AND customer_id IN (1, 2, 3);   -- VIP customers only

-- Comments with JOIN
SELECT 
    o.order_id,
    c.customer_name     -- Full name from customers table
FROM orders o
JOIN customers c        -- Join to get customer details
    ON o.customer_id = c.customer_id;  -- Match on ID

-- Comment before GROUP BY
SELECT 
    category,
    COUNT(*) as product_count
FROM products
-- Group by product category
GROUP BY category;

-- Comment in CASE statement
SELECT 
    customer_id,
    CASE 
        WHEN total_orders > 100 THEN 'VIP'        -- High volume
        WHEN total_orders > 50 THEN 'Premium'     -- Medium volume
        WHEN total_orders > 10 THEN 'Regular'     -- Low volume
        ELSE 'New'                                 -- First-time customer
    END as customer_tier
FROM customer_summary;

-- Long comment that should wrap
SELECT 
    id,
    -- This is a very long comment that explains something complex about this column and should wrap at around 100 characters to maintain readability
    value
FROM table1;

-- SQL keywords in strings (should not trigger formatting)
SELECT 
    'SELECT * FROM customers WHERE status = ''active''' as example_query,
    'This string contains SELECT and FROM keywords' as description,
    'JOIN is also a keyword' as another_example
FROM dual;

-- Strings with quotes
SELECT 
    name,
    REPLACE(name, '''', '') as name_without_quotes,
    'Customer''s order' as description
FROM customers;

-- Comments containing SQL keywords
-- This comment mentions SELECT, FROM, WHERE and JOIN but should stay as-is
SELECT * FROM orders;

-- String with newline characters
SELECT 
    'Line 1
Line 2
Line 3' as multiline_string
FROM dual;

-- Comment at end of line with semicolon
SELECT * FROM customers;  -- This is the end

-- Multiple inline comments
SELECT 
    col1,  -- First column
    col2,  -- Second column  
    col3   -- Third column
FROM table1;

-- Comments in subquery
SELECT *
FROM (
    -- This is a subquery
    SELECT 
        customer_id,
        COUNT(*) as order_count  -- Count orders per customer
    FROM orders
    GROUP BY customer_id
) subquery;

-- Block comment with special characters
/*
 * Special characters: @#$%^&*()
 * SQL keywords: SELECT FROM WHERE
 * Code example: SELECT * FROM table;
 */
SELECT * FROM customers;

-- Comment alignment in CASE
SELECT 
    order_id,
    CASE 
        WHEN amount > 1000 THEN 'High'     -- Large orders
        WHEN amount > 100 THEN 'Medium'    -- Medium orders
        ELSE 'Low'                         -- Small orders
    END as order_size
FROM orders;

-- Comments in CTE
WITH 
-- First CTE - active customers
active_customers AS (
    SELECT customer_id, name
    FROM customers
    WHERE status = 'active'  -- Only active accounts
),
-- Second CTE - recent orders
recent_orders AS (
    SELECT customer_id, order_id, order_date
    FROM orders
    WHERE order_date >= '2024-01-01'  -- This year only
)
SELECT 
    ac.name,
    ro.order_id  -- Order reference
FROM active_customers ac
JOIN recent_orders ro ON ac.customer_id = ro.customer_id;

-- String concatenation with quotes
SELECT 
    CONCAT('Customer: ', name, ' (', email, ')') as customer_info,
    'Status: ' || status as status_info
FROM customers;

-- Comments before semicolon
SELECT * FROM orders
-- This query retrieves all orders
;

-- Comment between statements
SELECT * FROM customers;
-- Next query
SELECT * FROM orders;

-- Nested block comments (some databases support)
/*
 * Outer comment
 * /* Inner comment */
 * Still in outer
 */
SELECT * FROM products;

-- Comment with special formatting
-- ==========================================
-- IMPORTANT QUERY - DO NOT MODIFY
-- ==========================================
SELECT * FROM critical_table;

-- Inline comment in window function
SELECT 
    employee_id,
    salary,
    AVG(salary) OVER (PARTITION BY department) as dept_avg  -- Department average
FROM employees;

-- Comment in aggregate
SELECT 
    department,
    SUM(salary) as total_salary,  -- Total department salary
    AVG(salary) as avg_salary,    -- Average department salary
    COUNT(*) as employee_count    -- Number of employees
FROM employees
GROUP BY department;

-- String with escaped characters
SELECT 
    'Tab:\t Newline:\n Quote:\" Backslash:\\' as escaped_chars
FROM dual;

-- Comment with URLs and emails
-- For more info: https://example.com/docs
-- Contact: support@example.com
SELECT * FROM help_topics;

-- Multi-line string in CASE
SELECT 
    id,
    CASE 
        WHEN type = 'A' THEN 'This is a very long string that describes type A with lots of detail'
        WHEN type = 'B' THEN 'This is a very long string that describes type B with lots of detail'
        ELSE 'Default description'
    END as description
FROM items;

-- Comments in named_struct
SELECT 
    id,
    named_struct(
        'name', customer_name,     -- Customer's full name
        'email', email,            -- Contact email address
        'phone', phone             -- Phone number
    ) as contact_info
FROM customers;
