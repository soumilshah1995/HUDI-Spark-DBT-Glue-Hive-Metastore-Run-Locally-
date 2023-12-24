{{
    config(
        materialized='incremental',
        file_format='hudi',
        unique_key='id'
    )
}}

with source_data as (

    select format_number(rand()*1000, 0) as id
    union all
    select null as id

    )

select *
from source_data
where id is not null
