-- Standardize address data

SELECT
    CAST(addressid AS BIGINT) AS address_id,
    addressline1 AS address_line_1,
    addressline2 AS address_line_2,
    city,
    CAST(stateprovinceid AS BIGINT) AS state_province_id,
    postalcode AS postal_code,
    rowguid,
    CAST(modifieddate AS TIMESTAMP) AS modified_at

FROM {{ source('adventure_works', 'person_address') }}

-- Notes:
    -- Exclude unnecessary contact and demographic information

-- dbt run --select stg_person__address