{{
  config(
    materialized = 'incremental',
    unique_key = 'HOST_ID',
    )
}}

select 
    HOST_ID,
    REPLACE(HOST_NAME,' ','_') AS HOST_NAME,
    HOST_SINCE,
    IS_SUPERHOST,
    RESPONSE_RATE,
    CASE 
        when RESPONSE_RATE > 95 THEN 'EXCELLENT'
        WHEN RESPONSE_RATE > 80 THEN 'VERY GOOD'
        WHEN RESPONSE_RATE > 70 THEN 'GOOD'
        WHEN RESPONSE_RATE > 60 THEN 'FAIR'
        ELSE 'POOR'
    END AS RATING,
    CREATED_AT
from    
    {{ ref('bronze_hosts') }}