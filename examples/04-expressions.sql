-- =============================================================================
-- 04-expressions.sql
-- Complex expressions: CASE, window functions, nested functions
-- =============================================================================

-- Simple CASE statement
SELECT 
    employee_id,
    name,
    CASE 
        WHEN salary > 100000 THEN 'High'
        WHEN salary > 50000 THEN 'Medium'
        ELSE 'Low'
    END as salary_tier
FROM employees;

-- CASE with multiple conditions in WHEN
SELECT 
    order_id,
    CASE 
        WHEN status = 'shipped' AND delivery_date < expected_date THEN 'Early'
        WHEN status = 'shipped' AND delivery_date = expected_date THEN 'On Time'
        WHEN status = 'shipped' AND delivery_date > expected_date THEN 'Late'
        WHEN status = 'pending' THEN 'Not Shipped'
        ELSE 'Unknown'
    END as delivery_status
FROM orders;

-- Nested CASE statements
SELECT 
    customer_id,
    CASE 
        WHEN country = 'US' THEN 
            CASE 
                WHEN state IN ('CA', 'NY', 'TX') THEN 'Major State'
                ELSE 'Other State'
            END
        WHEN country IN ('UK', 'FR', 'DE') THEN 'Europe'
        ELSE 'Other Country'
    END as location_category
FROM customers;

-- CASE in aggregate
SELECT 
    department,
    COUNT(*) as total_employees,
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) as female_count,
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) as male_count
FROM employees
GROUP BY department;

-- Simple CASE (value-based)
SELECT 
    order_id,
    CASE status
        WHEN 'P' THEN 'Pending'
        WHEN 'S' THEN 'Shipped'
        WHEN 'D' THEN 'Delivered'
        WHEN 'C' THEN 'Cancelled'
        ELSE 'Unknown'
    END as status_description
FROM orders;

-- Window function: ROW_NUMBER
SELECT 
    employee_id,
    name,
    department,
    salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) as salary_rank
FROM employees;

-- Window function: RANK and DENSE_RANK
SELECT 
    product_id,
    product_name,
    sales,
    RANK() OVER (ORDER BY sales DESC) as sales_rank,
    DENSE_RANK() OVER (ORDER BY sales DESC) as dense_rank
FROM products;

-- Window function with frame specification
SELECT 
    date,
    revenue,
    AVG(revenue) OVER (
        ORDER BY date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as moving_avg_7day
FROM daily_sales;

-- Multiple window functions
SELECT 
    employee_id,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) as dept_avg_salary,
    MAX(salary) OVER (PARTITION BY department) as dept_max_salary,
    MIN(salary) OVER (PARTITION BY department) as dept_min_salary,
    salary - AVG(salary) OVER (PARTITION BY department) as salary_diff_from_avg
FROM employees;

-- LAG and LEAD window functions
SELECT 
    date,
    revenue,
    LAG(revenue, 1) OVER (ORDER BY date) as prev_day_revenue,
    LEAD(revenue, 1) OVER (ORDER BY date) as next_day_revenue,
    revenue - LAG(revenue, 1) OVER (ORDER BY date) as day_over_day_change
FROM daily_sales;

-- NTILE for quartiles
SELECT 
    customer_id,
    total_purchases,
    NTILE(4) OVER (ORDER BY total_purchases DESC) as purchase_quartile
FROM customer_summary;

-- Window function with complex PARTITION BY
SELECT 
    sale_id,
    region,
    product_category,
    sale_amount,
    SUM(sale_amount) OVER (
        PARTITION BY region, product_category 
        ORDER BY sale_date
    ) as cumulative_sales
FROM sales;

-- FIRST_VALUE and LAST_VALUE
SELECT 
    employee_id,
    department,
    hire_date,
    FIRST_VALUE(employee_id) OVER (
        PARTITION BY department 
        ORDER BY hire_date
    ) as first_hire_in_dept,
    LAST_VALUE(employee_id) OVER (
        PARTITION BY department 
        ORDER BY hire_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) as last_hire_in_dept
FROM employees;

-- Nested function calls
SELECT 
    customer_id,
    UPPER(TRIM(SUBSTRING(email, 1, POSITION('@' IN email) - 1))) as username
FROM customers;

-- Complex arithmetic expressions
SELECT 
    product_id,
    (price * 1.15) * (1 - discount_pct / 100) as final_price_with_tax,
    ROUND((quantity * price * (1 - discount_pct / 100)), 2) as total_after_discount
FROM order_items;

-- String functions nested
SELECT 
    CONCAT(
        UPPER(SUBSTRING(first_name, 1, 1)),
        LOWER(SUBSTRING(first_name, 2)),
        ' ',
        UPPER(SUBSTRING(last_name, 1, 1)),
        LOWER(SUBSTRING(last_name, 2))
    ) as formatted_name
FROM employees;

-- Date functions
SELECT 
    order_id,
    order_date,
    DATE_ADD(order_date, INTERVAL 30 DAY) as expected_delivery,
    DATEDIFF(CURRENT_DATE, order_date) as days_since_order,
    EXTRACT(YEAR FROM order_date) as order_year,
    EXTRACT(MONTH FROM order_date) as order_month
FROM orders;

-- COALESCE and NULLIF
SELECT 
    customer_id,
    COALESCE(phone_mobile, phone_home, phone_work, 'No phone') as contact_phone,
    NULLIF(discount_code, '') as valid_discount_code
FROM customers;

-- Array/Map functions (Spark specific - will add more in 05-spark-specific)
SELECT 
    id,
    ARRAY(col1, col2, col3) as value_array,
    SIZE(ARRAY(col1, col2, col3)) as array_size
FROM source_table;

-- Complex CASE with window function
SELECT 
    employee_id,
    salary,
    department,
    CASE 
        WHEN salary > AVG(salary) OVER (PARTITION BY department) THEN 'Above Average'
        WHEN salary = AVG(salary) OVER (PARTITION BY department) THEN 'Average'
        ELSE 'Below Average'
    END as salary_category
FROM employees;

-- CASE inside window function
SELECT 
    sale_id,
    product_type,
    SUM(CASE WHEN status = 'completed' THEN amount ELSE 0 END) 
        OVER (PARTITION BY product_type ORDER BY sale_date) as cumulative_completed_sales
FROM sales;
