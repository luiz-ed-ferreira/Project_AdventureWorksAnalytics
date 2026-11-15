
-- Consolidate product attributes with their category hierarchy
-- Grain: one row per product

WITH products AS (
    SELECT *
    FROM {{ ref('int_sales__product') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} AS product_key,
    product_id,
    product_name,
    product_number,
    product_category_id,
    product_category_name,
    product_subcategory_id,
    product_subcategory_name,
    product_model_id,
    is_manufactured_in_house,
    is_finished_good,
    color,
    size,
    size_unit_measure_code,
    weight,
    weight_unit_measure_code,
    safety_stock_level,
    reorder_point,
    standard_cost,
    list_price,
    days_to_manufacture,
    product_line,
    product_class,
    product_style,
    sell_start_date,
    sell_end_date,
    discontinued_date,
    product_modified_at,
    subcategory_modified_at,
    category_modified_at
FROM products

-- dbt run --select dim_product