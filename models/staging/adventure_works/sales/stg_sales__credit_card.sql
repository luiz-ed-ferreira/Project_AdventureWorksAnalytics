-- Standardize credit card data

SELECT
    CAST(creditcardid AS BIGINT) AS credit_card_id,
    cardtype AS card_type,
    CAST(modifieddate AS TIMESTAMP) AS modified_at

FROM {{ source('adventure_works', 'sales_creditcard') }}

--Notes:
    -- Exclude sensitive card numbers and unused expiration details

-- dbt run --select stg_sales__credit_card
