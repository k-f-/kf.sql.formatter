-- =============================================================================
-- 02-ctes-subqueries.sql
-- CTEs (Common Table Expressions) and subqueries
-- =============================================================================

-- Simple CTE
WITH active_users AS (
    SELECT user_id, name, email
    FROM users
    WHERE status = 'active'
)
SELECT * FROM active_users;

-- Multiple CTEs
WITH 
high_value_customers AS (
    SELECT customer_id, SUM(order_total) as lifetime_value
    FROM orders
    GROUP BY customer_id
    HAVING SUM(order_total) > 10000
),
recent_purchases AS (
    SELECT customer_id, MAX(order_date) as last_purchase
    FROM orders
    GROUP BY customer_id
)
SELECT 
    hvc.customer_id,
    hvc.lifetime_value,
    rp.last_purchase
FROM high_value_customers hvc
JOIN recent_purchases rp ON hvc.customer_id = rp.customer_id;

-- Nested CTE
WITH 
base_data AS (
    SELECT * FROM sales WHERE year = 2024
),
aggregated AS (
    SELECT 
        region,
        SUM(revenue) as total_revenue
    FROM base_data
    GROUP BY region
),
ranked AS (
    SELECT 
        region,
        total_revenue,
        RANK() OVER (ORDER BY total_revenue DESC) as revenue_rank
    FROM aggregated
)
SELECT * FROM ranked WHERE revenue_rank <= 10;

-- CTE with complex query
WITH monthly_metrics AS (
    SELECT 
        DATE_TRUNC('month', order_date) as month,
        COUNT(DISTINCT customer_id) as unique_customers,
        COUNT(*) as order_count,
        SUM(order_total) as revenue
    FROM orders
    WHERE order_date >= '2024-01-01'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    month,
    unique_customers,
    order_count,
    revenue,
    revenue / order_count as avg_order_value,
    revenue / unique_customers as revenue_per_customer
FROM monthly_metrics
ORDER BY month;

-- Scalar subquery in SELECT
SELECT 
    customer_id,
    name,
    (SELECT COUNT(*) FROM orders WHERE orders.customer_id = customers.customer_id) as order_count
FROM customers;

-- Subquery in WHERE
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Subquery in FROM (derived table)
SELECT avg_price_by_category.category, avg_price_by_category.avg_price
FROM (
    SELECT category, AVG(price) as avg_price
    FROM products
    GROUP BY category
) avg_price_by_category
WHERE avg_price_by_category.avg_price > 100;

-- Correlated subquery
SELECT e1.employee_id, e1.name, e1.salary
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department = e1.department
);

-- EXISTS subquery
SELECT customer_id, name
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.order_date >= '2024-01-01'
);

-- NOT EXISTS
SELECT product_id, product_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi
    WHERE oi.product_id = p.product_id
);

-- IN with subquery
SELECT name, department
FROM employees
WHERE department IN (
    SELECT department
    FROM departments
    WHERE budget > 1000000
);

-- CTE referenced multiple times
WITH product_stats AS (
    SELECT 
        product_id,
        COUNT(*) as order_count,
        SUM(quantity) as total_quantity
    FROM order_items
    GROUP BY product_id
)
SELECT 
    p.product_name,
    ps1.order_count,
    ps1.total_quantity,
    ps2.order_count as comparison_count
FROM products p
JOIN product_stats ps1 ON p.product_id = ps1.product_id
LEFT JOIN product_stats ps2 ON p.related_product_id = ps2.product_id;
