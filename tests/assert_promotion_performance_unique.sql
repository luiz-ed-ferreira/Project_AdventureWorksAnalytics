-- Ensure one record per product
-- Grain: product_key

SELECT
    product_key,
    COUNT(*) AS record_count
FROM {{ ref('rpt_sales__promotion_performance') }}
GROUP BY product_key
HAVING COUNT(*) > 1

-- dbt test --select assert_promotion_performance_unique