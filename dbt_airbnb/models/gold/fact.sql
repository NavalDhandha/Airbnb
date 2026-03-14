select  
    booking_id,
    listing_id,
    host_id,
    total_amount,
    accommodates,
    bedrooms,
    bathrooms,
    price_per_night,
    response_rate
from    
    {{ ref('obt') }}