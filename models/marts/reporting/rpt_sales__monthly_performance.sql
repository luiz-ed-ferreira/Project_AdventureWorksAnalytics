-- Monthly sales performance overview
-- Grain: one row per calendar month

WITH sales AS (
    SELECT
        d.year,
        d.month,
        d.month_name,
        COUNT(DISTINCT f.sales_order_id) AS total_orders,
        SUM(f.order_quantity) AS total_quantity,
        SUM(f.gross_sales_amount) AS gross_sales,
        SUM(f.discount_amount) AS total_discounts,
        SUM(f.net_sales_amount) AS net_sales
    FROM {{ ref('fact_sales') }} AS f
    INNER JOIN {{ ref('dim_date') }} AS d
        ON f.order_date_key = d.date_key
    GROUP BY
        d.year,
        d.month,
        d.month_name
)

SELECT
    year,
    month,
    month_name,
    total_orders,
    total_quantity,
    gross_sales,
    total_discounts,
    net_sales,
    net_sales / NULLIF(total_orders, 0) AS average_order_value
FROM sales

-- dbt run --select rpt_sales__monthly_performance