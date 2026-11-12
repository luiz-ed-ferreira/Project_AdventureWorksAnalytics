
-- Standardize sales order detail data

SELECT
    CAST(salesorderid AS BIGINT) AS sales_order_id,
    CAST(salesorderdetailid AS BIGINT) AS sales_order_detail_id,
    carriertrackingnumber AS carrier_tracking_number,
    CAST(orderqty AS INT) AS order_quantity,
    CAST(productid AS BIGINT) AS product_id,
    CAST(specialofferid AS BIGINT) AS special_offer_id,
    CAST(unitprice AS DECIMAL(19, 4)) AS unit_price,
    CAST(unitpricediscount AS DECIMAL(19, 4)) AS unit_price_discount,
    rowguid,
    CAST(modifieddate AS TIMESTAMP) AS modified_at

FROM {{ source('adventure_works', 'sales_salesorderdetail') }}

-- dbt run --select stg_sales__sales_order_detail