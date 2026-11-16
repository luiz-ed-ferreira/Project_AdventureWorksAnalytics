-- Validate the uniqueness of the composite key (sales_order_id, sales_order_detail_id)
-- Each sales order can contain multiple order details, but each order-detail combination must appear only once
-- Returns records only when duplicate combinations are found

SELECT
    sales_order_id,
    sales_order_detail_id,
    COUNT(*) AS record_count
FROM {{ ref('fact_sales') }}
GROUP BY
    sales_order_id,
    sales_order_detail_id
HAVING COUNT(*) > 1

-- dbt test --select assert_fact_sales_unique