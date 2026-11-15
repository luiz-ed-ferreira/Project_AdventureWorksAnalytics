-- Consolidate sales territory attributes and financial performance metrics
-- Grain: one row per sales territory

WITH sales_territories AS (
    SELECT *
    FROM {{ ref('int_sales__sales_territory') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['territory_id']) }} AS sales_territory_key,
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

-- dbt run --select dim_sales_territory