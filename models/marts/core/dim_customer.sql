-- Consolidate customer attributes from individual and store records
-- Grain: one row per customer

WITH customers AS (
    SELECT *
    FROM {{ ref('int_sales__customer') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['customer_id']) }} AS customer_key,
    customer_id,
    person_id,
    store_id,
    territory_id,
    person_type,
    person_name_style,
    person_title,
    first_name,
    middle_name,
    last_name,
    person_suffix,
    store_name,
    salesperson_id,
    customer_modified_at,
    person_modified_at,
    store_modified_at
FROM customers

-- dbt run --select dim_customer