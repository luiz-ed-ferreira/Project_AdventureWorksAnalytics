-- Consolidate address attributes with state, province, and country information
-- Grain: one row per address

WITH geography AS (
    SELECT *
    FROM {{ ref('int_sales__geography') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['address_id']) }} AS geography_key,
    address_id,
    address_line_1,
    address_line_2,
    city,
    postal_code,
    state_province_id,
    state_province_code,
    state_province_name,
    is_only_state_province,

    territory_id,

    country_region_code,
    country_region_name,

    address_modified_at,
    state_province_modified_at,
    country_region_modified_at

FROM geography

-- dbt run --select dim_geography