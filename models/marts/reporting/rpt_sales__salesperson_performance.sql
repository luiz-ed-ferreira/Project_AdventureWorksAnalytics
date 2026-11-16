-- Salesperson performance overview
-- Grain: one row per salesperson with sales

WITH salesperson_sales AS (
    SELECT
        f.salesperson_key,
        COUNT(DISTINCT f.sales_order_id) AS total_orders,
        SUM(f.order_quantity) AS total_quantity,
        SUM(f.gross_sales_amount) AS gross_sales,
        SUM(f.discount_amount) AS total_discounts,
        SUM(f.net_sales_amount) AS net_sales
    FROM {{ ref('fact_sales') }} AS f
    WHERE f.salesperson_key IS NOT NULL
    GROUP BY
        f.salesperson_key
)

SELECT
    s.salesperson_key,
    s.sales_person_id,
    s.first_name,
    s.middle_name,
    s.last_name,
    s.job_title,
    s.territory_id,
    s.sales_quota,
    s.bonus,
    s.commission_pct,
    s.sales_ytd,
    s.sales_last_year,
    ss.total_orders,
    ss.total_quantity,
    ss.gross_sales,
    ss.total_discounts,
    ss.net_sales,
    ss.net_sales / NULLIF(ss.total_orders, 0) AS average_order_value
FROM salesperson_sales AS ss
INNER JOIN {{ ref('dim_salesperson') }} AS s
    ON ss.salesperson_key = s.salesperson_key

-- dbt run --select rpt_sales__salesperson_performance