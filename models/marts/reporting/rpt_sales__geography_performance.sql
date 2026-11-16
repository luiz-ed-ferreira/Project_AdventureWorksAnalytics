-- Geographic sales performance overview
-- Grain: one row per shipping address

WITH geography_sales AS (
    SELECT
        f.ship_to_geography_key AS geography_key,
        COUNT(DISTINCT f.sales_order_id) AS total_orders,
        SUM(f.order_quantity) AS total_quantity,
        SUM(f.gross_sales_amount) AS gross_sales,
        SUM(f.discount_amount) AS total_discounts,
        SUM(f.net_sales_amount) AS net_sales
    FROM {{ ref('fact_sales') }} AS f
    WHERE f.ship_to_geography_key IS NOT NULL
    GROUP BY
        f.ship_to_geography_key
)

SELECT
    g.geography_key,
    g.city,
    g.state_province_code,
    g.state_province_name,
    g.country_region_code,
    g.country_region_name,
    g.postal_code,
    gs.total_orders,
    gs.total_quantity,
    gs.gross_sales,
    gs.total_discounts,
    gs.net_sales,
    gs.net_sales / NULLIF(gs.total_orders, 0) AS average_order_value
FROM geography_sales AS gs
INNER JOIN {{ ref('dim_geography') }} AS g
    ON gs.geography_key = g.geography_key

-- dbt run --select rpt_sales__geography_performance