-- Standardize state and province data.

SELECT
    CAST(stateprovinceid AS BIGINT) AS state_province_id,
    stateprovincecode AS state_province_code,
    countryregioncode AS country_region_code,
    isonlystateprovinceflag AS is_only_state_province,
    name AS state_province_name,
    CAST(territoryid AS BIGINT) AS territory_id,
    rowguid,
    CAST(modifieddate AS TIMESTAMP) AS modified_at
FROM {{ source('adventure_works', 'person_stateprovince') }}

-- dbt run --select stg_person__state_province