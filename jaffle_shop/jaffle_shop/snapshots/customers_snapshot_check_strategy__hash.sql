{% snapshot  customers_snapshot_check_strategy__hash %}
{{
    config(
        target_schema='snapshots',
        unique_key='CustomerId',
        strategy='check',
        check_cols=['HashDiff']
    )
}}

select
    *,
    {{
        dbt_utils.generate_surrogate_key(
            adapter.get_columns_in_relation(source('raw', 'customers')) | map(attribute='name') | list
        )
    }} as HashDiff
from {{ source('raw', 'customers') }}
{% endsnapshot %}
