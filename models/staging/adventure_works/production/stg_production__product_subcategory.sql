-- Standardize product subcategory data

SELECT
    CAST(productsubcategoryid AS BIGINT) AS product_subcategory_id,
    CAST(productcategoryid AS BIGINT) AS product_category_id,
    name AS product_subcategory_name,
    rowguid,
    CAST(modifieddate AS TIMESTAMP) AS modified_at

FROM {{ source('adventure_works', 'production_productsubcategory') }}

-- dbt run --select stg_production__product_subcategory