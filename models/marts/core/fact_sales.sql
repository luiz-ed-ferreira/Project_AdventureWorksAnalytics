-- Fact table containing sales transactions at order detail level
-- Grain: one row per sales order detail
-- Business key: sales_order_id + sales_order_detail_id

WITH order_details AS (
    SELECT *
    FROM {{ ref('int_sales__order_details') }}
)

SELECT
    -- Degenerate dimensions
    sales.sales_order_id,
    sales.sales_order_detail_id,

    -- Date dimension keys
    order_date.date_key AS order_date_key,
    due_date.date_key AS due_date_key,
    ship_date.date_key AS ship_date_key,

    -- Dimension foreign keys
    product.product_key,
    customer.customer_key,
    credit_card.credit_card_key,
    salesperson.salesperson_key,
    sales_territory.sales_territory_key,

    -- Role-playing geography dimension keys
    bill_to_geography.geography_key AS bill_to_geography_key,
    ship_to_geography.geography_key AS ship_to_geography_key,

    -- Order attributes
    sales.order_status,
    sales.is_online_order,
    sales.ship_method_id,
    sales.special_offer_id,

    -- Sales measures
    sales.order_quantity,
    sales.unit_price,
    sales.unit_price_discount,
    sales.gross_sales_amount,
    sales.discount_amount,
    sales.net_sales_amount,

    -- Audit timestamps
    sales.detail_modified_at,
    sales.order_modified_at

FROM order_details AS sales

LEFT JOIN {{ ref('dim_date') }} AS order_date
    ON sales.order_date = order_date.date_day

LEFT JOIN {{ ref('dim_date') }} AS due_date
    ON sales.due_date = due_date.date_day

LEFT JOIN {{ ref('dim_date') }} AS ship_date
    ON sales.ship_date = ship_date.date_day

LEFT JOIN {{ ref('dim_product') }} AS product
    ON sales.product_id = product.product_id

LEFT JOIN {{ ref('dim_customer') }} AS customer
    ON sales.customer_id = customer.customer_id

LEFT JOIN {{ ref('dim_credit_card') }} AS credit_card
    ON sales.credit_card_id = credit_card.credit_card_id

LEFT JOIN {{ ref('dim_salesperson') }} AS salesperson
    ON sales.salesperson_id = salesperson.sales_person_id

LEFT JOIN {{ ref('dim_sales_territory') }} AS sales_territory
    ON sales.territory_id = sales_territory.territory_id

LEFT JOIN {{ ref('dim_geography') }} AS bill_to_geography
    ON sales.bill_to_address_id = bill_to_geography.address_id

LEFT JOIN {{ ref('dim_geography') }} AS ship_to_geography
    ON sales.ship_to_address_id = ship_to_geography.address_id

-- dbt run --select fact_sales