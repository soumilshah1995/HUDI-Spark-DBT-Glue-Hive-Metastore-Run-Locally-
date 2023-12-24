{{ config(
    materialized='table',
    table='date_dimension',
    unique_key='id'
) }}


WITH date_dimension_data AS (
    SELECT
        date(d) AS id,
        d AS full_date,
        EXTRACT(YEAR FROM d) AS year,
        EXTRACT(WEEK FROM d) AS year_week,
        EXTRACT(DAY FROM d) AS year_day,
        EXTRACT(YEAR FROM d) AS fiscal_year,
        EXTRACT(QUARTER FROM d) AS fiscal_qtr,
        EXTRACT(MONTH FROM d) AS month,
        date_format(d, 'MMMM') AS month_name,
        EXTRACT(DOW FROM d) AS week_day,
        date_format(d, 'EEEE') AS day_name,
        (CASE WHEN date_format(d, 'EEEE') NOT IN ('Sunday', 'Saturday') THEN 0 ELSE 1 END) AS day_is_weekday
    FROM
        (SELECT EXPLODE(months) AS d FROM (SELECT SEQUENCE (TO_DATE('2000-01-01'), TO_DATE('2023-01-01'), INTERVAL 1 DAY) AS months))
)

SELECT
    id,
    full_date,
    year,
    year_week,
    year_day,
    fiscal_year,
    fiscal_qtr,
    month,
    month_name,
    week_day,
    day_name,
    day_is_weekday
FROM
    date_dimension_data;
