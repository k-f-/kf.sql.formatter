-- =============================================================================
-- 08-edge-cases.sql
-- Edge cases and stress tests for the formatter
-- =============================================================================

-- Empty query (just whitespace)


-- Single word
SELECT

-- Very short query
SELECT 1;

-- Query with only comments
-- Comment 1
-- Comment 2
/* Block comment */

-- Extremely long line (should break or stay based on config)
SELECT customer_id, customer_name, customer_email, customer_phone, customer_address, customer_city, customer_state, customer_zip, customer_country, customer_created_at, customer_updated_at, customer_status FROM customers WHERE status = 'active' AND created_at >= '2024-01-01';

-- Deeply nested subqueries
SELECT *
FROM (
    SELECT *
    FROM (
        SELECT *
        FROM (
            SELECT *
            FROM (
                SELECT *
                FROM base_table
                WHERE level = 5
            ) level_4
            WHERE level >= 4
        ) level_3
        WHERE level >= 3
    ) level_2
    WHERE level >= 2
) level_1
WHERE level >= 1;

-- Deeply nested CASE statements
SELECT 
    id,
    CASE 
        WHEN condition1 THEN 
            CASE 
                WHEN condition2 THEN 
                    CASE 
                        WHEN condition3 THEN 'Level 3'
                        ELSE 'Level 2 Else'
                    END
                ELSE 'Level 1 Else'
            END
        ELSE 'Top Level Else'
    END as nested_result
FROM table1;

-- Many columns in SELECT
SELECT 
    col1, col2, col3, col4, col5, col6, col7, col8, col9, col10,
    col11, col12, col13, col14, col15, col16, col17, col18, col19, col20,
    col21, col22, col23, col24, col25, col26, col27, col28, col29, col30
FROM wide_table;

-- Many JOINs
SELECT *
FROM t1
JOIN t2 ON t1.id = t2.id
JOIN t3 ON t2.id = t3.id
JOIN t4 ON t3.id = t4.id
JOIN t5 ON t4.id = t5.id
JOIN t6 ON t5.id = t6.id
JOIN t7 ON t6.id = t7.id
JOIN t8 ON t7.id = t8.id
JOIN t9 ON t8.id = t9.id
JOIN t10 ON t9.id = t10.id;

-- Many WHERE conditions
SELECT *
FROM table1
WHERE condition1 = 1
  AND condition2 = 2
  AND condition3 = 3
  AND condition4 = 4
  AND condition5 = 5
  AND condition6 = 6
  AND condition7 = 7
  AND condition8 = 8
  AND condition9 = 9
  AND condition10 = 10
  AND condition11 = 11
  AND condition12 = 12
  AND condition13 = 13
  AND condition14 = 14
  AND condition15 = 15;

-- Complex expression with many nested functions
SELECT 
    id,
    UPPER(TRIM(SUBSTRING(REPLACE(LOWER(CONCAT(first_name, ' ', last_name)), 'test', ''), 1, 50))) as processed_name
FROM customers;

-- Unusual whitespace
SELECT     id,    name,     email   
FROM    customers   
WHERE   status='active'AND   country  =  'US';

-- Mixed case keywords
SeLeCt Id, NaMe 
FrOm CuStOmErS 
wHeRe StAtUs = 'AcTiVe';

-- No spaces
SELECT id,name,email FROM customers WHERE status='active'AND country='US';

-- Excessive spaces
SELECT                 id,                  name
FROM                          customers
WHERE                             status                =                   'active';

-- Empty CASE
SELECT 
    id,
    CASE 
        WHEN 1=1 THEN NULL
    END as empty_case
FROM table1;

-- CASE with only ELSE
SELECT 
    id,
    CASE 
        ELSE 'default'
    END as only_else
FROM table1;

-- Empty CTE
WITH empty_cte AS (
    SELECT 1 WHERE 1=0
)
SELECT * FROM empty_cte;

-- Multiple semicolons
SELECT * FROM customers;;
SELECT * FROM orders;;;

-- Semicolon at start
;SELECT * FROM customers;

-- No semicolon at end
SELECT * FROM customers

-- Comments everywhere
/* Start */ SELECT /* middle */ * /* end */ FROM /* table */ customers /* where */ WHERE /* condition */ status = 'active' /* final */;

-- Single column with very long alias
SELECT 
    very_long_column_name_that_goes_on_and_on_and_on as extremely_long_alias_name_that_is_very_descriptive
FROM table1;

-- Expression with all operators
SELECT 
    (a + b - c * d / e % f) as arithmetic,
    (a = b AND c != d OR e < f AND g > h AND i <= j AND k >= l) as logical,
    (a || b) as concatenation,
    (a IN (1,2,3) AND b NOT IN (4,5,6)) as membership,
    (a BETWEEN 1 AND 100) as range,
    (a LIKE '%pattern%' AND b NOT LIKE '%other%') as pattern,
    (a IS NULL OR b IS NOT NULL) as nullcheck
FROM complex_table;

-- Very long string literal
SELECT 
    'This is an extremely long string literal that contains a lot of text and might need special handling by the formatter to ensure it does not break the layout or cause issues with line length' as long_string
FROM dual;

-- String with SQL keywords and special characters
SELECT 
    'SELECT * FROM table WHERE id = 1; DROP TABLE users; -- malicious' as sql_injection_example,
    'C:\path\to\file.txt' as windows_path,
    '/usr/local/bin/script.sh' as unix_path,
    'email@domain.com' as email,
    'https://example.com/page?param=value&other=123' as url
FROM dual;

-- Unicode and special characters
SELECT 
    'café' as french,
    '日本語' as japanese,
    '🔥💻🚀' as emoji,
    '→←↑↓' as arrows,
    'α β γ δ' as greek
FROM dual;

-- Numeric edge cases
SELECT 
    0 as zero,
    -1 as negative,
    9999999999999999999 as very_large,
    0.000000000001 as very_small,
    1e10 as scientific,
    0x1A as hex,
    0b1010 as binary
FROM dual;

-- NULL handling
SELECT 
    NULL as null_value,
    NULL + 1 as null_arithmetic,
    CASE WHEN NULL THEN 'yes' ELSE 'no' END as null_condition,
    COALESCE(NULL, NULL, 'default') as null_coalesce
FROM dual;

-- Empty GROUP BY
SELECT 
    COUNT(*) as total
FROM table1
GROUP BY ();

-- Window function edge cases
SELECT 
    id,
    ROW_NUMBER() OVER () as row_num,
    COUNT(*) OVER () as total_count
FROM table1;

-- Circular alias reference (should fail or handle)
SELECT 
    col1 as col2,
    col2 as col3,
    col3 as col1
FROM table1;

-- Reserved keywords as identifiers
SELECT 
    `select`,
    `from`,
    `where`,
    `group`,
    `order`,
    `having`,
    `join`,
    `union`
FROM `table`;

-- Chained CTEs with same name reuse
WITH temp AS (
    SELECT 1 as x
),
temp2 AS (
    SELECT x FROM temp
),
temp3 AS (
    SELECT x FROM temp2
)
SELECT * FROM temp3;

-- Extremely nested parentheses
SELECT 
    ((((((((((1))))))))) + ((((((((((2))))))))) * (((((((((3)))))))))) as nested_parens
FROM dual;

-- Mixed quotes
SELECT 
    "double_quoted_column",
    'single_quoted_string',
    `backtick_identifier`
FROM `table`;

-- Tab characters (may not display properly)
SELECT	id,	name,	email
FROM	customers
WHERE	status	=	'active';

-- Trailing comma (invalid SQL but might appear)
SELECT 
    col1,
    col2,
    col3,
FROM table1;

-- Leading comma (valid in some dialects)
SELECT 
    col1
    ,col2
    ,col3
FROM table1;

-- Query with no FROM clause
SELECT 1 + 1 as result;

SELECT CURRENT_TIMESTAMP as now;

-- Multiple statements on one line
SELECT * FROM t1; SELECT * FROM t2; SELECT * FROM t3;

-- Statement with only comments
-- Just a comment, no actual SQL

/* Another comment block */

-- Incomplete query
SELECT * FROM

-- Unmatched parentheses
SELECT * FROM (SELECT 1;

SELECT * FROM table1);

-- Mixed line endings (may need special handling)
-- This file might have CRLF, LF, or CR endings

-- Query that is exactly 100 characters (boundary test)
SELECT col1, col2, col3, col4, col5 FROM table1 WHERE status = 'active' AND id > 100;

-- Query that is 101 characters (just over boundary)
SELECT col1, col2, col3, col4, col5 FROM table1 WHERE status = 'active' AND id > 1000;
