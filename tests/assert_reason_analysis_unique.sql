-- Ensure one record per sales reason
-- Grain: sales_reason_key

SELECT
    sales_reason_key,
    COUNT(*) AS record_count
FROM {{ ref('rpt_sales__reason_analysis') }}
GROUP BY
    sales_reason_key
HAVING COUNT(*) > 1

-- dbt test --select assert_reason_analysis_unique