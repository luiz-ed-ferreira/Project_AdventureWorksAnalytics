
-- Generate a continuous calendar dimension
-- Grain: one row per calendar date

WITH date_spine AS (
    SELECT
        EXPLODE(
            SEQUENCE(
                DATE('2011-01-01'),
                DATE('2014-12-31'),
                INTERVAL 1 DAY
            )
        ) AS date_day
)
-- Obs.: date range based on the sales data reference period (2011–2014)

SELECT
    CAST(DATE_FORMAT(date_day, 'yyyyMMdd') AS INT) AS date_key,
    date_day,
    YEAR(date_day) AS year,
    QUARTER(date_day) AS quarter,
    MONTH(date_day) AS month,
    DATE_FORMAT(date_day, 'MMMM') AS month_name,
    DATE_FORMAT(date_day, 'MMM') AS month_short_name,
    DAY(date_day) AS day_of_month,
    DAYOFYEAR(date_day) AS day_of_year,
    DAYOFWEEK(date_day) AS day_of_week,
    DATE_FORMAT(date_day, 'EEEE') AS day_name,
    DATE_FORMAT(date_day, 'EEE') AS day_short_name,
    WEEKOFYEAR(date_day) AS week_of_year,

    CASE
        WHEN DAYOFWEEK(date_day) IN (1, 7) THEN TRUE
        ELSE FALSE
    END AS is_weekend,

    CASE
        WHEN DAY(date_day) = 1 THEN TRUE
        ELSE FALSE
    END AS is_first_day_of_month,

    CASE
        WHEN date_day = LAST_DAY(date_day) THEN TRUE
        ELSE FALSE
    END AS is_last_day_of_month

FROM date_spine

-- dbt run --select dim_date