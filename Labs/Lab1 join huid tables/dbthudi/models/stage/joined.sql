{{ config(
    materialized='incremental',
    file_format='hudi',
    unique_key='customer_id,order_id'
)}}

WITH
  customer_data AS (
    SELECT
      customer_id,
      name AS customer_name,
      city,
      email,
      created_at AS customer_created_at,
      address,
      state
    FROM {{ source('data_source', 'customers') }}
  ),
  order_data AS (
    SELECT
      o.order_id,
      o.name AS order_name,
      o.order_value,
      o.priority,
      o.order_date,
      o.customer_id
    FROM {{ source('data_source', 'orders') }} o
  )


SELECT c.customer_id,
       c.customer_name,
       c.city,
       c.email,
       c.customer_created_at,
       c.address,
       c.state,
       o.order_id,
       o.order_name,
       o.order_value,
       o.priority,
       o.order_date
FROM customer_data c
         JOIN order_data o ON c.customer_id = o.customer_id;
