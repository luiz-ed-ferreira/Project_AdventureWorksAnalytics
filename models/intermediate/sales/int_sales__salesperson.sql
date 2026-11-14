-- Integrate salesperson records with their associated employee and person attributes
-- Grain: one row per sales_person_id

WITH salespeople AS (
    SELECT *
    FROM {{ ref('stg_sales__sales_person') }}
),
employees AS (
    SELECT *
    FROM {{ ref('stg_person__employee') }}
),
persons AS (
    SELECT *
    FROM {{ ref('stg_person__person') }}
)

SELECT
    -- Salesperson identifiers
    salespeople.sales_person_id,
    salespeople.territory_id,

    -- Employee attributes
    employees.job_title,
    employees.hire_date,
    employees.current_flag,

    -- Person attributes
    persons.person_type,
    persons.name_style,
    persons.title AS person_title,
    persons.first_name,
    persons.middle_name,
    persons.last_name,
    persons.suffix,

    -- Sales performance attributes
    salespeople.sales_quota,
    salespeople.bonus,
    salespeople.commission_pct,
    salespeople.sales_ytd,
    salespeople.sales_last_year,

    -- Modification timestamps
    salespeople.modified_at AS salesperson_modified_at,
    employees.modified_at AS employee_modified_at,
    persons.modified_at AS person_modified_at

FROM salespeople
LEFT JOIN employees
    ON salespeople.sales_person_id = employees.business_entity_id
LEFT JOIN persons
    ON employees.business_entity_id = persons.person_id

-- dbt run --select int_sales__salesperson