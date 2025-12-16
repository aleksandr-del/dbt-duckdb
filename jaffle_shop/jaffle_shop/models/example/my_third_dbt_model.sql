{{
    config(
        materialized="table"
    )
}}

with cte as (
    select
        *
    from {{ source('raw', 'orders') }}
    limit 10
)

select * from cte
