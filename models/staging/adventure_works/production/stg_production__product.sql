-- Standardize product data

SELECT
    CAST(productid AS BIGINT) AS product_id,
    name AS product_name,
    productnumber AS product_number,
    makeflag AS is_manufactured_in_house,
    finishedgoodsflag AS is_finished_good,
    color,
    CAST(safetystocklevel AS INT) AS safety_stock_level,
    CAST(reorderpoint AS INT) AS reorder_point,
    CAST(standardcost AS DECIMAL(19, 4)) AS standard_cost,
    CAST(listprice AS DECIMAL(19, 4)) AS list_price,
    size,
    sizeunitmeasurecode AS size_unit_measure_code,
    weightunitmeasurecode AS weight_unit_measure_code,
    CAST(weight AS DECIMAL(19, 4)) AS weight,
    CAST(daystomanufacture AS INT) AS days_to_manufacture,
    productline AS product_line,
    class AS product_class,
    style AS product_style,
    CAST(productsubcategoryid AS BIGINT) AS product_subcategory_id,
    CAST(productmodelid AS BIGINT) AS product_model_id,
    CAST(sellstartdate AS DATE) AS sell_start_date,
    CAST(sellenddate AS DATE) AS sell_end_date,
    CAST(NULL AS DATE) AS discontinued_date,
    rowguid,
    CAST(modifieddate AS TIMESTAMP) AS modified_at
FROM {{ source('adventure_works', 'production_product') }}

-- dbt run --select stg_production__product