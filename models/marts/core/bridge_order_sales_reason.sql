-- Bridge table connecting sales orders to their associated sales reasons
-- Grain: one row per sales order and sales reason combination

SELECT
    order_reasons.sales_order_id,
    sales_reason.sales_reason_key,
    order_reasons.sales_reason_id,
    order_reasons.association_modified_at,
    order_reasons.reason_modified_at
FROM {{ ref('int_sales__order_reasons') }} AS order_reasons
LEFT JOIN {{ ref('dim_sales_reason') }} AS sales_reason
    ON order_reasons.sales_reason_id = sales_reason.sales_reason_id

-- dbt run --select bridge_order_sales_reason