{{
  config(
    materialized = 'ephemeral',
    )
}}

with bookings as (
select  
    booking_id,
    booking_date,
    booking_status,
    CREATED_AT
from    
    {{ ref('obt') }}
)
select * from bookings