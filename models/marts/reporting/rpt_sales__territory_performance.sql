-- Sales territory performance overview
-- Grain: one row per sales territory with sales

WITH territory_sales AS (
    SELECT
        f.sales_territory_key,
        COUNT(DISTINCT f.sales_order_id) AS total_orders,
        SUM(f.order_quantity) AS total_quantity,
        SUM(f.gross_sales_amount) AS gross_sales,
        SUM(f.discount_amount) AS total_discounts,
        SUM(f.net_sales_amount) AS net_sales
    FROM {{ ref('fact_sales') }} AS f
    WHERE f.sales_territory_key IS NOT NULL
    GROUP BY
        f.sales_territory_key
)

SELECT
    t.sales_territory_key,
    t.territory_id,
    t.territory_name,
    t.country_region_code,
    t.territory_group,
    t.sales_ytd,
    t.sales_last_year,
    t.cost_ytd,
    t.cost_last_year,
    ts.total_orders,
    ts.total_quantity,
    ts.gross_sales,
    ts.total_discounts,
    ts.net_sales,
    ts.net_sales / NULLIF(ts.total_orders, 0) AS average_order_value
FROM territory_sales AS ts
INNER JOIN {{ ref('dim_sales_territory') }} AS t
    ON ts.sales_territory_key = t.sales_territory_key

-- dbt run --select rpt_sales__territory_performance