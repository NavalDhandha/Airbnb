{% set nights_booked = 3 %}

select * from {{ ref('bronze_bookings') }}
where nights_booked > {{ nights_booked }}