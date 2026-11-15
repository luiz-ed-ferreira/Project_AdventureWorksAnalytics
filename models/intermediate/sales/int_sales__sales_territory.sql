-- Integrate and standardize sales territory attributes
-- Grain: one row per sales territory

WITH sales_territories AS (
    SELECT *
    FROM {{ ref('stg_sales__sales_territory') }}
)

SELECT
    territory_id,
    territory_name,
    country_region_code,
    territory_group,
    sales_ytd,
    sales_last_year,
    cost_ytd,
    cost_last_year,
    rowguid,
    modified_at
FROM sales_territories

-- dbt run --select int_sales__sales_territory