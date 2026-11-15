-- Consolidate credit card attributes for sales analysis
-- Grain: one row per credit card

WITH credit_cards AS (
    SELECT *
    FROM {{ ref('int_sales__credit_card') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['credit_card_id']) }} AS credit_card_key,
    credit_card_id,
    card_type,
    modified_at
FROM credit_cards

-- dbt run --select dim_credit_card