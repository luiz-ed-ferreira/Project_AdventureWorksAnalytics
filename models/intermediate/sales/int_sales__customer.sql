-- Integrate customer records with their associated person and store attributes
-- Grain: one row per customer

WITH customers AS (
    SELECT *
    FROM {{ ref('stg_sales__customer') }}
),
persons AS (
    SELECT *
    FROM {{ ref('stg_person__person') }}
),
stores AS (
    SELECT *
    FROM {{ ref('stg_sales__store') }}
)

SELECT
    -- Customer identifiers
    customers.customer_id,
    customers.person_id,
    customers.store_id,
    customers.territory_id,

    -- Person attributes
    persons.person_type,
    persons.name_style AS person_name_style,
    persons.title AS person_title,
    persons.first_name,
    persons.middle_name,
    persons.last_name,
    persons.suffix AS person_suffix,

    -- Store attributes
    stores.store_name,
    stores.salesperson_id,

    -- Modification timestamps
    customers.modified_at AS customer_modified_at,
    persons.modified_at AS person_modified_at,
    stores.modified_at AS store_modified_at

FROM customers
LEFT JOIN persons
    ON customers.person_id = persons.person_id
LEFT JOIN stores
    ON customers.store_id = stores.store_id

-- Notes:
    -- LEFT JOIN to preserve all customers, including those with no association to a person or store
    
-- dbt run --select int_sales__customer