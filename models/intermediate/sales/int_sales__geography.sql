-- Integrate address records with their associated state/province and country attributes
-- Grain: one row per address

WITH addresses AS (
    SELECT *
    FROM {{ ref('stg_person__address') }}
),
states AS (
    SELECT *
    FROM {{ ref('stg_person__state_province') }}
),
countries AS (
    SELECT *
    FROM {{ ref('stg_person__country_region') }}
)

SELECT
    -- Address identifiers and attributes
    addresses.address_id,
    addresses.address_line_1,
    addresses.address_line_2,
    addresses.city,
    addresses.postal_code,

    -- State/province attributes
    addresses.state_province_id,
    states.state_province_code,
    states.state_province_name,
    states.is_only_state_province,
    states.territory_id,

    -- Country attributes
    states.country_region_code,
    countries.country_region_name,

    -- Modification timestamps
    addresses.modified_at AS address_modified_at,
    states.modified_at AS state_province_modified_at,
    countries.modified_at AS country_region_modified_at

FROM addresses
LEFT JOIN states
    ON addresses.state_province_id = states.state_province_id
LEFT JOIN countries
    ON states.country_region_code = countries.country_region_code

-- dbt run --select int_sales__geography