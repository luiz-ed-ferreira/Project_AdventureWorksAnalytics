
-- Standardize sales order and sales reason associations

SELECT
    CAST(salesorderid AS BIGINT) AS sales_order_id,
    CAST(salesreasonid AS BIGINT) AS sales_reason_id,
    CAST(modifieddate AS TIMESTAMP) AS modified_at

FROM {{ source('adventure_works', 'sales_salesorderheadersalesreason') }}

-- dbt run --select stg_sales__sales_order_header_sales_reason