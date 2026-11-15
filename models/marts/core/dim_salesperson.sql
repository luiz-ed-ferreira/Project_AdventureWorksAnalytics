-- Consolidate salesperson attributes with employee and personal information
-- Grain: one row per salesperson

WITH salespeople AS (
    SELECT *
    FROM {{ ref('int_sales__salesperson') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['sales_person_id']) }} AS salesperson_key,
    sales_person_id,
    territory_id,
    job_title,
    hire_date,
    current_flag,
    person_type,
    name_style,
    person_title,
    first_name,
    middle_name,
    last_name,
    suffix,
    sales_quota,
    bonus,
    commission_pct,
    sales_ytd,
    sales_last_year,
    salesperson_modified_at,
    employee_modified_at,
    person_modified_at
FROM salespeople

-- dbt run --select dim_salesperson
