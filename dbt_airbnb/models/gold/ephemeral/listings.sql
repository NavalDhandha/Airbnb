{{
  config(
    materialized = 'ephemeral',
    )
}}

with listings as (
select  
    listing_id,
    property_type,
    room_type,
    city,
    country,
    price_tag,
    listings_created
from    
    {{ ref('obt') }}
)
select * from listings