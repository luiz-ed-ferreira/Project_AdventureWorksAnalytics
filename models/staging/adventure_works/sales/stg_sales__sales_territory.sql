-- Standardize sales territory attributes from the source system
-- Grain: one row per sales territory

SELECT
    territoryid AS territory_id,
    TRIM(name) AS territory_name,
    TRIM(countryregioncode) AS country_region_code,
    TRIM(group) AS territory_group,

    CAST(salesytd AS DECIMAL(19,4)) AS sales_ytd,
    CAST(saleslastyear AS DECIMAL(19,4)) AS sales_last_year,
    CAST(costytd AS DECIMAL(19,4)) AS cost_ytd,
    CAST(costlastyear AS DECIMAL(19,4)) AS cost_last_year,

    rowguid,
    CAST(modifieddate AS TIMESTAMP) AS modified_at

FROM {{ source('adventure_works', 'sales_salesterritory') }}

-- dbt run --select stg_sales__sales_territory