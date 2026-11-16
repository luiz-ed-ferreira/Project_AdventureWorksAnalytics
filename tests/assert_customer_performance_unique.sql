-- Ensure one record per customer
-- Grain: customer_key

SELECT
    customer_key,
    COUNT(*) AS record_count

FROM {{ ref('rpt_sales__customer_performance') }}

GROUP BY
    customer_key

HAVING COUNT(*) > 1

-- dbt test --select assert_customer_performance_unique