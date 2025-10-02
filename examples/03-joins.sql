-- =============================================================================
-- 03-joins.sql
-- All types of JOIN operations
-- =============================================================================

-- Simple INNER JOIN
SELECT 
    o.order_id,
    o.order_date,
    c.customer_name
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- LEFT JOIN
SELECT 
    c.customer_id,
    c.customer_name,
    o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- RIGHT JOIN
SELECT 
    o.order_id,
    c.customer_name
FROM orders o
RIGHT JOIN customers c ON o.customer_id = c.customer_id;

-- FULL OUTER JOIN
SELECT 
    c.customer_id,
    c.customer_name,
    o.order_id
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;

-- Multiple JOINs
SELECT 
    o.order_id,
    c.customer_name,
    p.product_name,
    oi.quantity
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

-- JOIN with multiple conditions
SELECT 
    e1.employee_name,
    e2.manager_name
FROM employees e1
JOIN employees e2 
    ON e1.manager_id = e2.employee_id 
   AND e1.department = e2.department;

-- JOIN with complex ON clause
SELECT 
    s.sale_id,
    c.customer_name,
    p.product_name
FROM sales s
JOIN customers c 
    ON s.customer_id = c.customer_id 
   AND s.sale_date >= c.registration_date
JOIN products p 
    ON s.product_id = p.product_id 
   AND p.category = 'Electronics';

-- Self-join
SELECT 
    e1.employee_name as employee,
    e2.employee_name as manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;

-- CROSS JOIN
SELECT 
    c.color,
    s.size
FROM colors c
CROSS JOIN sizes s;

-- JOIN with USING clause (1 column - should inline)
SELECT order_id, customer_name
FROM orders
JOIN customers USING (customer_id);

-- JOIN with USING clause (2+ columns - should break to multi-line)
SELECT *
FROM table1
JOIN table2 USING (id, department, location);

-- JOIN with WHERE filter
SELECT 
    o.order_id,
    c.customer_name,
    o.order_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_date >= '2024-01-01'
  AND c.country = 'US';

-- Multiple LEFT JOINs
SELECT 
    c.customer_id,
    c.customer_name,
    o.order_id,
    s.shipment_id,
    p.payment_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN shipments s ON o.order_id = s.order_id
LEFT JOIN payments p ON o.order_id = p.order_id;

-- Mixed JOIN types
SELECT 
    e.employee_name,
    d.department_name,
    p.project_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
LEFT JOIN employee_projects ep ON e.employee_id = ep.employee_id
LEFT JOIN projects p ON ep.project_id = p.project_id;

-- JOIN with subquery
SELECT 
    c.customer_name,
    summary.order_count,
    summary.total_spent
FROM customers c
JOIN (
    SELECT 
        customer_id,
        COUNT(*) as order_count,
        SUM(order_total) as total_spent
    FROM orders
    GROUP BY customer_id
) summary ON c.customer_id = summary.customer_id;

-- JOIN with CTE
WITH top_customers AS (
    SELECT customer_id, SUM(order_total) as lifetime_value
    FROM orders
    GROUP BY customer_id
    ORDER BY lifetime_value DESC
    LIMIT 100
)
SELECT 
    c.customer_name,
    c.email,
    tc.lifetime_value
FROM customers c
JOIN top_customers tc ON c.customer_id = tc.customer_id;

-- NATURAL JOIN (Spark/Databricks specific)
SELECT *
FROM table1
NATURAL JOIN table2;

-- LATERAL VIEW (Spark specific)
SELECT id, exploded_col
FROM source_table
LATERAL VIEW EXPLODE(array_column) t AS exploded_col;

-- Short JOIN (should inline if ≤100 chars)
SELECT * FROM orders o JOIN customers c ON o.customer_id = c.customer_id;
