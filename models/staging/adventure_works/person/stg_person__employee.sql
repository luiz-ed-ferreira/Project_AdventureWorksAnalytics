-- Select relevant employee attributes for sales analysis
-- Grain: one row per business_entity_id

SELECT
    businessentityid AS business_entity_id,
    TRIM(jobtitle) AS job_title,
    CAST(hiredate AS DATE) AS hire_date,
    currentflag AS current_flag,
    CAST(modifieddate AS TIMESTAMP) AS modified_at
FROM {{ source('adventure_works', 'humanresources_employee') }}

-- dbt run --select stg_person__employee