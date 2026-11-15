-- Validate the uniqueness of the composite key (sales_order_id, sales_reason_id)
-- Each sales order can have multiple reasons, and each reason can be associated
-- with multiple orders, but each order-reason combination must appear only once
-- Returns records only when duplicate combinations are found

SELECT
    sales_order_id,
    sales_reason_id,
    COUNT(*) AS record_count
FROM {{ ref('bridge_order_sales_reason') }}
GROUP BY
    sales_order_id,
    sales_reason_id
HAVING COUNT(*) > 1

-- dbt test --select assert_bridge_order_sales_reason_unique