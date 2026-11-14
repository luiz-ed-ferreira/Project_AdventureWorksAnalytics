-- Integrate sales order details with sales order header attributes
-- Grain: one row per sales order detail

WITH order_details AS (
    SELECT *
    FROM {{ ref('stg_sales__sales_order_detail') }}
),
order_headers AS (
    SELECT *
    FROM {{ ref('stg_sales__sales_order_header') }}
),

base_metrics AS (
    SELECT
        -- Transaction identifiers
        detail.sales_order_id,
        detail.sales_order_detail_id,

        -- Order attributes
        header.order_date,
        header.due_date,
        header.ship_date,
        header.status AS order_status,
        header.is_online_order,

        -- Business entity identifiers
        header.customer_id,
        header.salesperson_id,
        header.territory_id,
        header.bill_to_address_id,
        header.ship_to_address_id,
        header.ship_method_id,
        header.credit_card_id,

        -- Product and order detail attributes
        detail.product_id,
        detail.special_offer_id,
        detail.carrier_tracking_number,
        detail.order_quantity,
        detail.unit_price,
        detail.unit_price_discount,

        -- Financial metrics (2/3)
        CAST(
            detail.unit_price * detail.order_quantity
            AS DECIMAL(19, 4)
        ) AS gross_sales_amount,

        CAST(
            detail.unit_price
            * detail.order_quantity
            * detail.unit_price_discount
            AS DECIMAL(19, 4)
        ) AS discount_amount,

        detail.modified_at AS detail_modified_at,
        header.modified_at AS order_modified_at

    FROM order_details AS detail
    INNER JOIN order_headers AS header
        ON detail.sales_order_id = header.sales_order_id
)

-- Financial metrics (3/3)
-- To preserve double precision it is necessary separate the calculation of net sales amount from the base metrics CTE
SELECT
    *,
    CAST(
        gross_sales_amount - discount_amount
        AS DECIMAL(19, 4)
    ) AS net_sales_amount
FROM base_metrics

-- dbt run --select int_sales__order_details