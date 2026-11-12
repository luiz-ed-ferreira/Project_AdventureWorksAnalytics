-- Standardize country and region data

SELECT
    countryregioncode AS country_region_code,
    name AS country_region_name,
    CAST(modifieddate AS TIMESTAMP) AS modified_at

FROM {{ source('adventure_works', 'person_countryregion') }}

--Notes:
    -- Preserve source country codes without imputing missing values

-- dbt run --select stg_person__country_region