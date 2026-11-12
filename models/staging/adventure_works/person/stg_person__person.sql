-- Standardize person data

SELECT
    CAST(businessentityid AS BIGINT) AS person_id,
    persontype AS person_type,
    namestyle AS name_style,
    title,
    firstname AS first_name,
    middlename AS middle_name,
    lastname AS last_name,
    suffix,
    rowguid,
    CAST(modifieddate AS TIMESTAMP) AS modified_at
FROM {{ source('adventure_works', 'person_person') }}

--Notes:
    -- Exclude unnecessary contact and demographic information

-- dbt run --select stg_person__person
