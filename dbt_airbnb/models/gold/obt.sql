{% set configs = [
    {
        'table': 'airbnb.silver.silver_bookings',
        'columns': 'bookings.*',
        'alias': 'bookings'
    },
    {
        'table': 'airbnb.silver.silver_listings',
        'columns': 'listings.host_id,listings.property_type,listings.room_type,listings.city,listings.country,listings.accommodates,listings.bedrooms,listings.bathrooms,listings.price_per_night,listings.price_tag,listings.created_at as listings_created',
        'alias': 'listings',
        'join_condition': 'bookings.listing_id = listings.listing_id'
    },
    {
        'table': 'airbnb.silver.silver_hosts',
        'columns': 'hosts.host_name,hosts.host_since,hosts.is_superhost,hosts.response_rate,hosts.rating,hosts.created_at as hosts_created',
        'alias': 'hosts',
        'join_condition': 'listings.host_id = hosts.host_id'
    }
]
%}


select 
    {% for item in configs %}
        {{ item.columns }}   
        {% if not loop.last %} , {% endif %}   
    {% endfor %}
from 
    {% for item in configs %}
        {% if loop.first %}
            {{ item.table }} as {{ item.alias }}
        {% else %}
            left join {{ item.table }} as {{ item.alias }}
            on {{ item.join_condition }}
        {% endif %}
    {% endfor %}
