{{
  config(
    materialized = 'incremental',
    unique_key = 'BOOKING_ID'
    )
}}

select 
    BOOKING_ID,
    LISTING_ID,
    BOOKING_DATE,
    {{ multiply('NIGHTS_BOOKED','BOOKING_AMOUNT',2) }} + CLEANING_FEE + SERVICE_FEE as total_amount,
    BOOKING_STATUS,
    CREATED_AT
from    
    {{ ref('bronze_bookings') }}