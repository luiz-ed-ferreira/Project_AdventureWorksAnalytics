-- Integrate credit card records for dimensional modeling
-- Grain: one row per credit card

SELECT
    credit_card_id,
    TRIM(card_type) AS card_type,
    modified_at
FROM {{ ref('stg_sales__credit_card') }}

-- dbt run --select int_sales__credit_card