{{ config(materialized='table') }}

-- set up all necessary data
WITH fhv_trips AS (
    SELECT * FROM {{ ref('stg_fhv_trips_data') }}
), 

dim_zones AS (
    SELECT * FROM {{ ref('dim_zones') }}
    WHERE borough != 'Unknown'
) 

-- main query
SELECT
    fhv_trips.dispatching_base_num, 
    fhv_trips.pickup_datetime, 
    fhv_trips.dropoff_datetime,
    fhv_trips.pickup_locationid, 
    pickup_zone.borough AS pickup_borough, 
    pickup_zone.zone AS pickup_zone, 
    fhv_trips.dropoff_locationid,
    dropoff_zone.borough AS dropoff_borough, 
    dropoff_zone.zone AS dropoff_zone, 
    fhv_trips.sr_flag, 
    fhv_trips.affiliated_base_number
FROM fhv_trips
INNER JOIN dim_zones AS pickup_zone
ON fhv_trips.pickup_locationid = pickup_zone.locationid
INNER JOIN dim_zones AS dropoff_zone
ON fhv_trips.dropoff_locationid = dropoff_zone.locationid