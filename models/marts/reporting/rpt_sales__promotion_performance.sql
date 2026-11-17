-- Promotion sales performance by product
-- Grain: one row per product sold in orders associated with Promotion

WITH promotion_orders AS (
    SELECT DISTINCT
        b.sales_order_id
    FROM {{ ref('bridge_order_sales_reason') }} AS b
    INNER JOIN {{ ref('dim_sales_reason') }} AS r
        ON b.sales_reason_key = r.sales_reason_key
    WHERE LOWER(r.sales_reason_type) = 'promotion'
),

promotion_sales AS (
    SELECT
        f.product_key,
        COUNT(DISTINCT f.sales_order_id) AS total_orders,
        SUM(f.order_quantity) AS total_quantity,
        SUM(f.gross_sales_amount) AS gross_sales,
        SUM(f.discount_amount) AS total_discounts,
        SUM(f.net_sales_amount) AS net_sales
    FROM {{ ref('fact_sales') }} AS f
    INNER JOIN promotion_orders AS p
        ON f.sales_order_id = p.sales_order_id
    GROUP BY
        f.product_key
)

SELECT
    p.product_key,
    p.product_id,
    p.product_name,
    p.product_subcategory_name,
    p.product_category_name,
    ps.total_orders,
    ps.total_quantity,
    ps.gross_sales,
    ps.total_discounts,
    ps.net_sales,
    ps.net_sales / NULLIF(ps.total_quantity, 0) AS average_selling_price
FROM promotion_sales AS ps
INNER JOIN {{ ref('dim_product') }} AS p
    ON ps.product_key = p.product_key

-- dbt run --select rpt_sales__promotion_performance