-- =============================================================================
-- Test CASE Suite 8: Edge Cases
  and Stress Tests
-- =============================================================================

-- TC8.1: Very long column list

;
select
  a
  ,b
  ,c
  ,d
  ,e
  ,f
  ,g
  ,h
  ,i
  ,j
  ,k
  ,l
  ,m
  ,n
  ,o
  ,p
  ,q
  ,r
  ,s
  ,t
  ,u
  ,v
  ,w
  ,x
  ,y
  ,z
from alphabet_table

-- TC8.2: Deeply nested subqueries

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
  user_id
  ,name
from users
where status = 'active'
  ) level1
where name IS NOT NULL
  ) level2
where user_id > 0
  ) level3

-- TC8.3: Many JOINs

;
select
  *
from t1
join t2
on t1.id = t2.t1_id
join t3
on t2.id = t3.t2_id
join t4
on t3.id = t4.t3_id
join t5
on t4.id = t5.t4_id
join t6
on t5.id = t6.t5_id

-- TC8.4: Complex CASE

;
with many conditions
select
  id
  ,CASE
  WHEN value < 10 THEN 'Very Low'
  WHEN value >= 10 and value < 20 THEN 'Low'
  WHEN value >= 20 and value < 30 THEN 'Below Average'
  WHEN value >= 30 and value < 40 THEN 'Average'
  WHEN value >= 40 and value < 50 THEN 'Above Average'
  WHEN value >= 50 and value < 60 THEN 'Good'
  WHEN value >= 60 and value < 70 THEN 'Very Good'
  WHEN value >= 70 and value < 80 THEN 'Excellent'
  WHEN value >= 80 and value < 90 THEN 'Outstanding'
  WHEN value >= 90 THEN 'Perfect'
  ELSE 'Unknown'
  END                                                                                                                                                                                                                                                                                                                  as rating
from measurements

-- TC8.5: Single character column names
;
SELECT
  a
  ,b
  ,c
  ,d
  ,e FROM t                                                                                                                                                                                                                                                                                                             -- TC8.6: Unicode and special characters in identifiers
;
SELECT
  `user-id`
  ,`first name`
  ,`email@address`
  ,`créated_dáte` FROM `special-table`                                                                                                                                                                                                                                                                                  -- TC8.7: Empty
;
select(just *)
;
SELECT * FROM users                                                                                                                                                                                                                                                                                                     -- TC8.8:
;
SELECT
;
WITH no WHERE clause SELECT user_id, name, email FROM users                                                                                                                                                                                                                                                             -- TC8.9: Extremely long single line

select
  id
  ,name
  ,email
  ,phone
  ,address
  ,city
  ,state
  ,zipcode
  ,country
  ,created_at
  ,updated_at
  ,status
  ,type
  ,category
  ,subcategory
  ,description
  ,notes
  ,metadata
  ,tags
  ,preferences
  ,settings
from very_wide_table

-- TC8.10: Mixed whitespace(tabs and spaces)
;
SELECT
  user_id
  ,name
  ,email FROM users WHERE status = 'active'                                                                                                                                                                                                                                                                             -- TC8.11: Consecutive semicolons
;
SELECT id FROM t1;                                                                                                                                                                                                                                                                                                      -- TC8.12: No semicolon at END
;
SELECT id FROM t2                                                                                                                                                                                                                                                                                                       -- TC8.13: Multiple statements

;
with varying complexity
select
  id
from simple
;
select
  a
  ,b
  ,c
from medium
where x = 1
;
select
  t1.id
  ,t1.name
  ,t2.value
from complex t1
join other t2
on t1.id = t2.id
where t1.status = 'active'

-- TC8.14: Minimal query
;
SELECT 1                                                                                                                                                                                                                                                                                                                -- TC8.15: Query
WITH only comments                                                                                                                                                                                                                                                                                                      -- This is just a comment -- No actual SQL here -- SELECT id FROM fake
;