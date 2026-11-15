-- Consolidate sales reason attributes for business analysis
-- Grain: one row per sales reason

WITH sales_reasons AS (
    SELECT *
    FROM {{ ref('stg_sales__sales_reason') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['sales_reason_id']) }} AS sales_reason_key,
    sales_reason_id,
    sales_reason_name,
    sales_reason_type,
    modified_at
FROM sales_reasons

-- dbt run --select dim_sales_reason