-- Product sales performance overview
-- Grain: one row per product

WITH product_sales AS (
    SELECT
        f.product_key,
        COUNT(DISTINCT f.sales_order_id) AS total_orders,
        SUM(f.order_quantity) AS total_quantity,
        SUM(f.gross_sales_amount) AS gross_sales,
        SUM(f.discount_amount) AS total_discounts,
        SUM(f.net_sales_amount) AS net_sales
    FROM {{ ref('fact_sales') }} AS f
    GROUP BY
        f.product_key
)

SELECT
    p.product_key,
    p.product_id,
    p.product_name,
    p.product_number,
    p.product_category_id,
    p.product_category_name,
    p.product_subcategory_id,
    p.product_subcategory_name,
    ps.total_orders,
    ps.total_quantity,
    ps.gross_sales,
    ps.total_discounts,
    ps.net_sales,
    ps.net_sales / NULLIF(ps.total_quantity, 0) AS average_selling_price
FROM product_sales AS ps
INNER JOIN {{ ref('dim_product') }} AS p
    ON ps.product_key = p.product_key

-- dbt run --select rpt_sales__product_performance
