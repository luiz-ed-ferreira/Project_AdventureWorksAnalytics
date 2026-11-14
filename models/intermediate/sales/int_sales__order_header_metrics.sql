-- Prepare order-level financial metrics from sales order headers
-- Grain: one row per sales order

SELECT
    sales_order_id,
    order_date,
    customer_id,
    salesperson_id,
    territory_id,
    bill_to_address_id,
    ship_to_address_id,
    credit_card_id,
    status,
    is_online_order,
    CAST(subtotal AS DECIMAL(19, 4)) AS subtotal_amount,
    CAST(tax_amount AS DECIMAL(19, 4)) AS tax_amount,
    CAST(freight AS DECIMAL(19, 4)) AS freight_amount,
    CAST(total_due AS DECIMAL(19, 4)) AS total_due_amount,
    modified_at
FROM {{ ref('stg_sales__sales_order_header') }}

-- dbt run --select int_sales__order_header_metrics