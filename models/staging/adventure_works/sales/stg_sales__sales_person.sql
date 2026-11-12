-- Standardize sales person data

SELECT
    CAST(businessentityid AS BIGINT) AS sales_person_id,
    CAST(territoryid AS BIGINT) AS territory_id,
    CAST(salesquota AS DECIMAL(19, 4)) AS sales_quota,
    CAST(bonus AS DECIMAL(19, 4)) AS bonus,
    CAST(commissionpct AS DECIMAL(19, 4)) AS commission_pct,
    CAST(salesytd AS DECIMAL(19, 4)) AS sales_ytd,
    CAST(saleslastyear AS DECIMAL(19, 4)) AS sales_last_year,
    rowguid,
    CAST(modifieddate AS TIMESTAMP) AS modified_at

FROM {{ source('adventure_works', 'sales_salesperson') }}

-- dbt run --select stg_sales_sales_person
