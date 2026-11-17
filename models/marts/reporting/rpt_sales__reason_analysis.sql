-- Sales performance by sales reason
-- Grain: one row per sales reason
-- Financial metrics represent all sales from orders associated with each reason
-- Metrics are non-additive across reasons because an order may have multiple reasons

WITH reason_orders AS (
    SELECT DISTINCT
        b.sales_reason_key,
        b.sales_order_id
    FROM {{ ref('bridge_order_sales_reason') }} AS b
),
reason_sales AS (
    SELECT
        ro.sales_reason_key,
        COUNT(DISTINCT f.sales_order_id) AS total_orders,
        SUM(f.order_quantity) AS total_quantity,
        SUM(f.gross_sales_amount) AS gross_sales,
        SUM(f.discount_amount) AS total_discounts,
        SUM(f.net_sales_amount) AS net_sales
    FROM reason_orders AS ro
    INNER JOIN {{ ref('fact_sales') }} AS f
        ON ro.sales_order_id = f.sales_order_id
    GROUP BY
        ro.sales_reason_key
)

SELECT
    r.sales_reason_key,
    r.sales_reason_id,
    r.sales_reason_name,
    r.sales_reason_type,
    rs.total_orders,
    rs.total_quantity,
    rs.gross_sales,
    rs.total_discounts,
    rs.net_sales,
    rs.net_sales / NULLIF(rs.total_orders, 0) AS average_order_value
FROM reason_sales AS rs
INNER JOIN {{ ref('dim_sales_reason') }} AS r
    ON rs.sales_reason_key = r.sales_reason_key

-- dbt run --select rpt_sales__reason_analysis