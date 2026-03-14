{{
  config(
    materialized = 'ephemeral',
    )
}}

with hosts as (
select  
    host_id,
    host_name,
    host_since,
    is_superhost,
    rating,
    hosts_created
from    
    {{ ref('obt') }}
)
select * from hosts