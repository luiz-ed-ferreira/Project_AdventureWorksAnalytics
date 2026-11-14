-- Standardize country and region data

SELECT
    CASE
        WHEN countryregioncode IS NULL
            AND name = 'Namibia'
            THEN 'NA'
        ELSE TRIM(countryregioncode)
    END AS country_region_code,
    TRIM(name) AS country_region_name,
    CAST(modifieddate AS TIMESTAMP) AS modified_at
FROM {{ source('adventure_works', 'person_countryregion') }}

--Notes:
    -- For Namibia -> Expected ISO 3166-1 alpha-2 country code: 'NA'
    -- Proposed treatment -> Replace NULL with 'NA' in the transformation layer

-- dbt run --select stg_person__country_region