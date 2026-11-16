-- Customer sales performance overview
-- Grain: one row per customer with sales

WITH customer_sales AS (
    SELECT
        f.customer_key,
        COUNT(DISTINCT f.sales_order_id) AS total_orders,
        SUM(f.order_quantity) AS total_quantity,
        SUM(f.gross_sales_amount) AS gross_sales,
        SUM(f.discount_amount) AS total_discounts,
        SUM(f.net_sales_amount) AS net_sales
    FROM {{ ref('fact_sales') }} AS f
    GROUP BY
        f.customer_key
),
customers AS (
    SELECT
        customer_key,
        customer_id,
        CASE
            WHEN person_id IS NOT NULL AND store_id IS NOT NULL THEN 'Both'
            WHEN person_id IS NOT NULL THEN 'Person'
            WHEN store_id IS NOT NULL THEN 'Store'
            ELSE 'Unknown'
        END AS customer_type,
        COALESCE(
            store_name,
            CONCAT_WS(' ', first_name, middle_name, last_name)
        ) AS customer_name
    FROM {{ ref('dim_customer') }}
)

SELECT
    c.customer_key,
    c.customer_id,
    c.customer_name,
    c.customer_type,
    cs.total_orders,
    cs.total_quantity,
    cs.gross_sales,
    cs.total_discounts,
    cs.net_sales,
    cs.net_sales / NULLIF(cs.total_orders, 0) AS average_order_value
FROM customer_sales AS cs
INNER JOIN customers AS c
    ON cs.customer_key = c.customer_key

-- dbt run --select rpt_sales__customer_performance