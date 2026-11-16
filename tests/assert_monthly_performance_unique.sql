-- Ensure one record per calendar month
-- Grain: year + month

SELECT
    year,
    month,
    COUNT(*) AS record_count
FROM {{ ref('rpt_sales__monthly_performance') }}
GROUP BY
    year,
    month
HAVING COUNT(*) > 1

-- dbt test --select assert_monthly_performance_unique