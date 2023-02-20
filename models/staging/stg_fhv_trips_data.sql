{{ config(materialized='view') }}

SELECT
    dispatching_base_num, 
    pickup_datetime, 
    dropoff_datetime, 
    pulocationid AS pickup_locationid, 
    dolocationid AS dropoff_locationid, 
    sr_flag, 
    affiliated_base_number
FROM {{ source('staging', 'fhv_trips_data') }}
-- dbt run --select <model.sql> --var 'is_test_run: false'
{% if var('is_test_run', default=true) %}
    
    LIMIT 100

{% endif %}