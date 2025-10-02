-- =============================================================================
-- Test CASE Suite 6: Spark/Databricks Specific Features
-- =============================================================================

-- TC6.1: named_struct

select
  user_id
  ,named_struct(
'first_name'  , first_name
  'last_name'
  ,last_name
'email'       , email
  )                                                                                                                                                                                                                                                    as user_info
from users

-- TC6.2: Multiple named_struct calls

with alignment
select
  order_id
  'street'
  ,street
  ,'city'
  ,city
  ,'state'
  ,state)                                                                                                                                                                                                                                               as shipping_address
  'street'
  ,billing_street
  ,'city'
  ,billing_city
  ,'state'
  ,billing_state)                                                                                                                                                                                                                                       as billing_address
from orders

-- TC6.3:
  LATERAL VIEW
with explode
select
  user_id
  ,tag
from users
  LATERAL VIEW explode(tags) t                                                                                                                                                                                                                          as tag
where user_id > 1000

-- TC6.4:
  LATERAL VIEW
with posexplode
select
  product_id
  pos
  feature
from products
  LATERAL VIEW posexplode(features) t as pos, feature

-- TC6.5: Array functions
select
  order_id
  ,array_contains(tags, 'priority')                                                                                                                                                                                                                     as is_priority,
  array_size(items)                                                                                                                                                                                                                                     as item_count
  ,array_join(categories, ', ')                                                                                                                                                                                                                         as category_list
from orders

-- TC6.6: Map functions
select
  user_id
  ,map_keys(preferences)                                                                                                                                                                                                                                as preference_keys,
  map_values(preferences)                                                                                                                                                                                                                               as preference_values
  ,preferences['theme']                                                                                                                                                                                                                                 as theme_preference
from user_settings

-- TC6.7: Struct field access
select
  order_id
  address.street
  address.city
  address.state
  address.zipcode
from orders

-- TC6.8: Complex nested structures
select
  customer_id
  profile.personal_info.first_name
  profile.personal_info.last_name
  profile.contact_info.email
  profile.contact_info.phone
from customers

-- TC6.9: TRANSFORM function
select
  order_id
  ,transform(items, item -> item.price * 1.1)                                                                                                                                                                                                           as discounted_prices
from orders

-- TC6.10: Higher-order functions
with filter
select
  product_id
  ,filter(reviews, review -> review.rating >= 4)                                                                                                                                                                                                        as positive_reviews
from products
;