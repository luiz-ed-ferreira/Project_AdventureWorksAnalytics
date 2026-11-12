-- Standardize customer data

SELECT
    CAST(customerid AS BIGINT) AS customer_id,
    CAST(personid AS BIGINT) AS person_id,
    CAST(storeid AS BIGINT) AS store_id,
    CAST(territoryid AS BIGINT) AS territory_id,
    rowguid,
    CAST(modifieddate AS TIMESTAMP) AS modified_at

FROM {{ source('adventure_works', 'sales_customer') }}

-- dbt run --select stg_sales__customer