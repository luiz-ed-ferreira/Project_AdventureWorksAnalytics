-- Standardize sales store

SELECT
    businessentityid AS store_id,
    TRIM(name) AS store_name,
    salespersonid AS salesperson_id,
    CAST(modifieddate AS TIMESTAMP) AS modified_at
FROM {{ source('adventure_works', 'sales_store') }}

-- dbt run --select stg_sales__store