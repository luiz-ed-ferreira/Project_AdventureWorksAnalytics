-- Integrate sales orders with their associated sales reasons
-- Grain: one row per sales order and sales reason association

WITH order_reasons AS (
    SELECT *
    FROM {{ ref('stg_sales__sales_order_header_sales_reason') }}
),
sales_reasons AS (
    SELECT *
    FROM {{ ref('stg_sales__sales_reason') }}
)

SELECT
    order_reasons.sales_order_id,
    order_reasons.sales_reason_id,
    sales_reasons.sales_reason_name,
    sales_reasons.sales_reason_type,
    order_reasons.modified_at AS association_modified_at,
    sales_reasons.modified_at AS reason_modified_at
FROM order_reasons
INNER JOIN sales_reasons
    ON order_reasons.sales_reason_id = sales_reasons.sales_reason_id

-- dbt run --select int_sales__order_reasons