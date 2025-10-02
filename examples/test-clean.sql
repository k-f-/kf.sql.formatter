  -- Simple query to test formatting
select
  user_id
  ,first_name
  ,last_name
  ,email
  ,created_at
from customers
where country = 'US' and status = 'active'
order by created_at DESC
;
