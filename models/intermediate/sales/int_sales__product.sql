-- Integrate product records with their associated subcategory and category attributes
-- Grain: one row per product

WITH products AS (
    SELECT *
    FROM {{ ref('stg_production__product') }}
),
subcategories AS (
    SELECT *
    FROM {{ ref('stg_production__product_subcategory') }}
),
categories AS (
    SELECT *
    FROM {{ ref('stg_production__product_category') }}
)

SELECT
    -- Product attributes
    products.product_id,
    products.product_name,
    products.product_number,
    products.is_manufactured_in_house,
    products.is_finished_good,
    products.color,
    products.safety_stock_level,
    products.reorder_point,
    products.standard_cost,
    products.list_price,
    products.size,
    products.size_unit_measure_code,
    products.weight_unit_measure_code,
    products.weight,
    products.days_to_manufacture,
    products.product_line,
    products.product_class,
    products.product_style,
    products.product_model_id,

    -- Product hierarchy
    products.product_subcategory_id,
    subcategories.product_subcategory_name,
    subcategories.product_category_id,
    categories.product_category_name,

    -- Product lifecycle dates
    products.sell_start_date,
    products.sell_end_date,
    products.discontinued_date,

    -- Modification timestamps
    products.modified_at AS product_modified_at,
    subcategories.modified_at AS subcategory_modified_at,
    categories.modified_at AS category_modified_at

FROM products
LEFT JOIN subcategories
    ON products.product_subcategory_id = subcategories.product_subcategory_id
LEFT JOIN categories
    ON subcategories.product_category_id = categories.product_category_id

-- dbt run --select int_sales__product