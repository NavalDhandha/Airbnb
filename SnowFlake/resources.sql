CREATE FILE FORMAT IF NOT EXISTS csv_format
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;

SHOW FILE FORMATS;

CREATE OR REPLACE STAGE snowstage
    FILE_FORMAT = csv_format
    URL = '<storage_account_url>'
    CREDENTIALS=(AZURE_SAS_TOKEN='<access_token>');


COPY INTO bookings
    FROM @snowstage
    FILES=('bookings.csv');

select count(*) from bookings;

COPY INTO hosts
    FROM @snowstage
    FILES=('hosts.csv');

select count(*) from hosts;

COPY INTO listings
    FROM @snowstage
    FILES=('listings.csv');

select count(*) from listings; 
