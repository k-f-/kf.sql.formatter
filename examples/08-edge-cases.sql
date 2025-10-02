                                                                                                                                                                                                                                                                                                        -- =============================================================================
                                                                                                                                                                                                                                                                                                        -- 08-edge-cases.sql
                                                                                                                                                                                                                                                                                                        -- Edge cases and stress tests for the formatter
                                                                                                                                                                                                                                                                                                        -- =============================================================================

                                                                                                                                                                                                                                                                                                        -- Empty query(just whitespace)

                                                                                                                                                                                                                                                                                                        -- Single word
;
select

                                                                                                                                                                                                                                                                                                        -- Very short query
;
select
  1

                                                                                                                                                                                                                                                                                                        -- Query
;
with only comments
                                                                                                                                                                                                                                                                                                        -- Comment 1
                                                                                                                                                                                                                                                                                                        -- Comment 2
  /* Block comment */

                                                                                                                                                                                                                                                                                                        -- Extremely long line(should break or stay based
on config)
select
  customer_id, customer_name, customer_email, customer_phone, customer_address, customer_city, customer_state, customer_zip, customer_country, customer_created_at, customer_updated_at, customer_status
from customers
where status = 'active' and created_at >= '2024-01-01'

                                                                                                                                                                                                                                                                                                        -- Deeply nested subqueries
;
select
  *
from(
select
  *
from(
select
  *
from(
select
  *
from(
select
  *
from base_table
where level = 5
  ) level_4
where level >= 4
  ) level_3
where level >= 3
  ) level_2
where level >= 2
  ) level_1
where level >= 1

                                                                                                                                                                                                                                                                                                        -- Deeply nested CASE statements
;
select

  id
  ,CASE
  WHEN condition1 THEN
  CASE
  WHEN condition2 THEN
  CASE
  WHEN condition3 THEN 'Level 3'
  ELSE 'Level 2 ELSE'
  END
  ELSE 'Level 1 ELSE'
  END
  ELSE 'Top Level ELSE'
  END                                                                                                                                                                                                                                                                                                  as nested_result
from table1

                                                                                                                                                                                                                                                                                                        -- Many columns in
;
select
;
select

  col1, col2, col3, col4, col5, col6, col7, col8, col9, col10
  ,col11, col12, col13, col14, col15, col16, col17, col18, col19, col20,
  col21, col22, col23, col24, col25, col26, col27, col28, col29, col30
from wide_table

                                                                                                                                                                                                                                                                                                        -- Many JOINs
;
select
  *
from t1
join t2
on t1.id = t2.id
join t3
on t2.id = t3.id
join t4
on t3.id = t4.id
join t5
on t4.id = t5.id
join t6
on t5.id = t6.id
join t7
on t6.id = t7.id
join t8
on t7.id = t8.id
join t9
on t8.id = t9.id
join t10
on t9.id = t10.id

                                                                                                                                                                                                                                                                                                        -- Many
where conditions
;
select
  *
from table1
where condition1 = 1
  and condition2 = 2
  and condition3 = 3
  and condition4 = 4
  and condition5 = 5
  and condition6 = 6
  and condition7 = 7
  and condition8 = 8
  and condition9 = 9
  and condition10 = 10
  and condition11 = 11
  and condition12 = 12
  and condition13 = 13
  and condition14 = 14
  and condition15 = 15

                                                                                                                                                                                                                                                                                                        -- Complex expression
;
with many nested functions
select

  id
  ,upper(trim(substring(replace(lower(concat(first_name, ' ', last_name)), 'test', ''), 1, 50)))                                                                                                                                                                                                        as processed_name
from customers

                                                                                                                                                                                                                                                                                                        -- Unusual whitespace
;
select
  id,    name,     email
from    customers
where   status='active'and   country  =  'US'

                                                                                                                                                                                                                                                                                                        -- Mixed CASE keywords
;
select
  Id, NaMe
from CuStOmErS
where StAtUs = 'AcTiVe'

                                                                                                                                                                                                                                                                                                        -- No spaces
;
select
  id,name,email
from customers
where status='active'and country='US'

                                                                                                                                                                                                                                                                                                        -- Excessive spaces
;
select
  id,                  name
from                          customers
where                             status                =                   'active'

                                                                                                                                                                                                                                                                                                        -- Empty CASE
;
select

  id
  ,CASE
  WHEN 1=1 THEN NULL
  END                                                                                                                                                                                                                                                                                                  as empty_case
from table1

                                                                                                                                                                                                                                                                                                        -- CASE
;
with only ELSE
select

  id
  ,CASE
  ELSE 'default'
  END                                                                                                                                                                                                                                                                                                  as only_else
from table1

                                                                                                                                                                                                                                                                                                        -- Empty CTE
with empty_cte as(
select
  1
where 1=0
  )
;
select
  *
from empty_cte

                                                                                                                                                                                                                                                                                                        -- Multiple semicolons
;
select
  *
from customers;
select
  *
from orders;;

                                                                                                                                                                                                                                                                                                        -- Semicolon at start

;
select
  *
from customers

                                                                                                                                                                                                                                                                                                        -- No semicolon at END
;
select
  *
from customers

                                                                                                                                                                                                                                                                                                        -- Comments everywhere
  /* Start */
;
select
  /* middle */ * /* END */
from /* table */ customers /*
where */
where /* condition */ status = 'active' /* final */

                                                                                                                                                                                                                                                                                                        -- Single column
;
with very long alias
select

  very_long_column_name_that_goes_on_and_on_and_on                                                                                                                                                                                                                                                      as extremely_long_alias_name_that_is_very_descriptive
from table1

                                                                                                                                                                                                                                                                                                        -- Expression
;
with all operators
select
  (a + b - c * d / e % f)                                                                                                                                                                                                                                                                               as arithmetic
  ,(a = b and c != d or e < f and g > h and i <= j and k >= l)                                                                                                                                                                                                                                          as logical,
  (a || b)                                                                                                                                                                                                                                                                                              as concatenation
  ,(a in(1,2,3) and b NOT in(4,5,6))                                                                                                                                                                                                                                                                    as membership,
  (a BETWEEN 1 and 100)                                                                                                                                                                                                                                                                                 as range
  ,(a LIKE '%pattern%' and b NOT LIKE '%other%')                                                                                                                                                                                                                                                        as pattern,
  (a IS NULL or b IS NOT NULL)                                                                                                                                                                                                                                                                          as nullcheck
from complex_table

                                                                                                                                                                                                                                                                                                        -- Very long string literal
;
select

  'This is an extremely long string literal that contains a lot of text and might need special handling by the formatter to ensure it does not break the layout or cause issues
;
with line length'                                                                                                                                                                                                                                                                                       as long_string
from dual

                                                                                                                                                                                                                                                                                                        -- String
;
with SQL keywords and special characters
select

  '
;
select
  *
from table
where id = 1; DROP TABLE users; -- malicious'                                                        
                                -- as sql_injection_example
  ,'C:\path\to\file.txt'                                                                                                                                                                                                                                                                                as windows_path,
  '/usr/local/bin/script.sh'                                                                                                                                                                                                                                                                            as unix_path
  ,'email@domain.com'                                                                                                                                                                                                                                                                                   as email,
  'https://example.com/page?param=value&other=123'                                                                                                                                                                                                                                                      as url
from dual

                                                                                                                                                                                                                                                                                                        -- Unicode and special characters
;
select

  'café'                                                                                                                                                                                                                                                                                                as french
  ,'日本語'                                                                                                                                                                                                                                                                                                as japanese,
  '🔥💻🚀'                                                                                                                                                                                                                                                                                              as emoji
  ,'→←↑↓'                                                                                                                                                                                                                                                                                               as arrows,
  'α β γ δ'                                                                                                                                                                                                                                                                                             as greek
from dual

                                                                                                                                                                                                                                                                                                        -- Numeric edge cases
;
select

  0                                                                                                                                                                                                                                                                                                     as zero
  ,-1                                                                                                                                                                                                                                                                                                   as negative,
  9999999999999999999                                                                                                                                                                                                                                                                                   as very_large
  ,0.000000000001                                                                                                                                                                                                                                                                                       as very_small,
  1e10                                                                                                                                                                                                                                                                                                  as scientific
  ,0x1A                                                                                                                                                                                                                                                                                                 as hex,
  0b1010                                                                                                                                                                                                                                                                                                as binary
from dual

                                                                                                                                                                                                                                                                                                        -- NULL handling
;
select

  NULL                                                                                                                                                                                                                                                                                                  as null_value
  ,NULL + 1                                                                                                                                                                                                                                                                                             as null_arithmetic,
  CASE
         WHEN NULL THEN 'yes'
         ELSE 'no'
       END                                                                                                                                                                                                                                                                                             as null_condition
  ,coalesce(NULL, NULL, 'default')                                                                                                                                                                                                                                                                      as null_coalesce
from dual

                                                                                                                                                                                                                                                                                                        -- Empty
group by
;
select

  count(*)                                                                                                                                                                                                                                                                                              as total
from table1
group by()
select

  id
  ,row_number() over()                                                                                                                                                                                                                                                                                  as row_num,
  count(*) over()                                                                                                                                                                                                                                                                                       as total_count
from table1

                                                                                                                                                                                                                                                                                                        -- Circular alias reference(should fail or handle)
;
select

  col1                                                                                                                                                                                                                                                                                                  as col2
  ,col2                                                                                                                                                                                                                                                                                                 as col3,
  col3                                                                                                                                                                                                                                                                                                  as col1
from table1

  -- Reserved keywords                                                                                
  -- as identifiers
;
select

  `
;
select
  `
  ,`from`,
  `where`
  ,`group`,
  `order`
  ,`having`,
  `join`
  ,`union`
from `table`

                                                                                                                                                                                                                                                                                                        -- Chained CTEs
;
with same name reuse
with temp as(
select
  1                                                                                                                                                                                                                                                                                                     as x
  )
  ,temp2 as(
select
  x
from temp
  )
  ,temp3 as(
select
  x
from temp2
  )
select
  *
from temp3

                                                                                                                                                                                                                                                                                                        -- Extremely nested parentheses
;
select
  ((((((((((1))))))))) + ((((((((((2))))))))) * (((((((((3))))))))))                                                                                                                                                                                                                                    as nested_parens
from dual

                                                                                                                                                                                                                                                                                                        -- Mixed quotes
select

  "double_quoted_column"
  ,'single_quoted_string',
  `backtick_identifier`
from `table`

                                                                                                                                                                                                                                                                                                        -- Tab characters(may not display properly)
select
  id,	name,	email
from	customers
where	status	=	'active'

                                                                                                                                                                                                                                                                                                        -- Trailing comma(invalid SQL but might appear)
select

  col1
  ,col2,
  col3
,from table1

                                                                                                                                                                                                                                                                                                        -- Leading comma(valid in some dialects)
select

  col1
  ,col2
  ,col3
from table1

                                                                                                                                                                                                                                                                                                        -- Query
with no
from clause
select
  1 + 1                                                                                                                                                                                                                                                                                                 as result
select
  CURRENT_TIMESTAMP                                                                                                                                                                                                                                                                                     as now

                                                                                                                                                                                                                                                                                                        -- Multiple statements
on one line
select
  *
from t1
select
  *
from t2
select
  *
from t3

                                                                                                                                                                                                                                                                                                        -- Statement
with only comments
                                                                                                                                                                                                                                                                                                        -- Just a comment, no actual SQL

  /* Another comment block */

                                                                                                                                                                                                                                                                                                        -- Incomplete query
select
  *
from

                                                                                                                                                                                                                                                                                                        -- Unmatched parentheses
select
  *
from(
select
  1
select
  *
from table1)

                                                                                                                                                                                                                                                                                                        -- Mixed line endings(may need special handling)
                                                                                                                                                                                                                                                                                                        -- This file might have CRLF, LF, or CR endings

                                                                                                                                                                                                                                                                                                        -- Query that is exactly 100 characters(boundary test)
select
  col1, col2, col3, col4, col5
from table1
where status = 'active' and id > 100

                                                                                                                                                                                                                                                                                                        -- Query that is 101 characters(just over boundary)
select
  col1, col2, col3, col4, col5
from table1
where status = 'active' and id > 1000

                                                                                                                                                                                                                                                                                                        -- Window function edge cases
;
