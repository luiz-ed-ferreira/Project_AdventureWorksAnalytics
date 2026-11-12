
-- Standardize sales reason data

SELECT
    CAST(salesreasonid AS BIGINT) AS sales_reason_id,
    name AS sales_reason_name,
    reasontype AS sales_reason_type,
    CAST(modifieddate AS TIMESTAMP) AS modified_at

FROM {{ source('adventure_works', 'sales_salesreason') }}

-- dbt run --select stg_sales__sales_reason