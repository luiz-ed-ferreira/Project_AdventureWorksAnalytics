-- Ensure one record per sales person
-- Grain: salesperson_key

SELECT
    salesperson_key,
    COUNT(*) AS record_count
FROM {{ ref('rpt_sales__salesperson_performance') }}
GROUP BY salesperson_key
HAVING COUNT(*) > 1

-- dbt test --select rpt_sales__salesperson_performance