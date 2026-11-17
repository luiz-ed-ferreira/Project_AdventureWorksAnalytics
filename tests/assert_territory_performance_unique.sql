-- Ensure one record per territory
-- Grain: sales_territory_key

SELECT
    sales_territory_key,
    COUNT(*) AS record_count
FROM {{ ref('rpt_sales__territory_performance') }}
GROUP BY sales_territory_key
HAVING COUNT(*) > 1

-- dbt test --select assert_territory_performance_unique