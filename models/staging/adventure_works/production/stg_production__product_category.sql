-- Standardize product category data

SELECT
    CAST(productcategoryid AS BIGINT) AS product_category_id,
    name AS product_category_name,
    rowguid,
    CAST(modifieddate AS TIMESTAMP) AS modified_at

FROM {{ source('adventure_works', 'production_productcategory') }}

-- dbt run --select stg_production__product_category