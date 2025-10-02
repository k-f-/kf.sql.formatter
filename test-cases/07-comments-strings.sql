                                                                                                                                                                                                                                                                                                                                                                    -- =============================================================================
                                                                                                                                                                                                                                                                                                                                                                    -- Test CASE Suite 7: Comments
              and String Handling
                                                                                                                                                                                                                                                                                                                                                                    -- =============================================================================

                                                                                                                                                                                                                                                                                                                                                                    -- TC7.1: Inline comments after code
;
select

  user_id,                                                                                                                                                                                                                                                                                                                                                          -- Unique identifier
  name,                                                                                                                                                                                                                                                                                                                                                             -- full name of user
  email,                                                                                                                                                                                                                                                                                                                                                            -- Contact email
created_at                                                                                                                                                                                                                                                                                                                                                          -- Registration timestamp
from users

                                                                                                                                                                                                                                                                                                                                                                    -- TC7.2: Block comments
  /*
  This query retrieves all active users
  who have logged in within the last 30 days
  */
;
select
  user_id, name, last_login
from users
where status = 'active'
  and last_login >= CURRENT_DATE - INTERVAL '30 days'

                                                                                                                                                                                                                                                                                                                                                                    -- TC7.3: String
;
with SQL keywords
select

  comment_text
from comments
where comment_text LIKE '%
;
select
  %'
  or comment_text LIKE '%from%'
  or comment_text LIKE '%where%'

                                                                                                                                                                                                                                                                                                                                                                    -- TC7.4: String
;
with quotes
select

  product_name
  ,description,
  notes
from products
where description LIKE '%"premium"%'

                                                                                                                                                                                                                                                                                                                                                                    -- TC7.5: Multiple inline comments
;
with varying lengths
select

  a,                                                                                                                                                                                                                                                                                                                                                                -- Short comment
  b,                                                                                                                                                                                                                                                                                                                                                                -- Another short one
  c,                                                                                                                                                                                                                                                                                                                                                                -- This is a much longer comment that might need different alignment
  d                                                                                                                                                                                                                                                                                                                                                                 -- Final comment
from test_table

                                                                                                                                                                                                                                                                                                                                                                    -- TC7.6: Comment
;
with special characters
select

  user_id,                                                                                                                                                                                                                                                                                                                                                          -- User's id(primary key) - must be unique!
  email                                                                                                                                                                                                                                                                                                                                                             -- Email address: user@example.com format
from users

                                                                                                                                                                                                                                                                                                                                                                    -- TC7.7: Standalone comment lines
                                                                                                                                                                                                                                                                                                                                                                    -- This is a standalone comment
                                                                                                                                                                                                                                                                                                                                                                    -- It spans multiple lines
                                                                                                                                                                                                                                                                                                                                                                    -- and should not affect column alignment
;
select
  user_id, name
from users

                                                                                                                                                                                                                                                                                                                                                                    -- TC7.8: Mixed comment styles
;
select

  order_id,                                                                                                                                                                                                                                                                                                                                                         -- Order identifier
  /* Customer info */ customer_id
  ,                                                                                                                                                                                                                                                                                                                                                                 -- Order details
  order_date
  ,total_amount        /* Including tax */
from orders

                                                                                                                                                                                                                                                                                                                                                                    -- TC7.9: Long comment that should wrap
;
select

  product_id
  ,product_name,                                                                                                                                                                                                                                                                                                                                                    -- This is a very long comment that describes the product name field in great detail
                                                                                                                                                                                                                                                                                                                                                                    -- and
                                                                                                                                                                                                                                                                                                                                                                    -- should
                                                                                                                                                                                                                                                                                                                                                                    -- potentially
                                                                                                                                                                                                                                                                                                                                                                    -- be
                                                                                                                                                                                                                                                                                                                                                                    -- wrapped
                                                                                                                                                                                                                                                                                                                                                                    -- if
                                                                                                                                                                                                                                                                                                                                                                    -- it
                                                                                                                                                                                                                                                                                                                                                                    -- exceeds
                                                                                                                                                                                                                                                                                                                                                                    -- the
                                                                                                                                                                                                                                                                                                                                                                    -- configured
                                                                                                                                                                                                                                                                                                                                                                    -- column
                                                                                                                                                                                                                                                                                                                                                                    -- width
  price
from products

                                                                                                                                                                                                                                                                                                                                                                    -- TC7.10: Empty/blank comments
;
select

  a,                                                                                                                                                                                                                                                                                                                                                                --
  b,                                                                                                                                                                                                                                                                                                                                                                --
  c                                                                                                                                                                                                                                                                                                                                                                 --
from test_table
  or notes = 'It''s a great product'
