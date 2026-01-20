{% snapshot customers_snapshot_timestamp_strategy %}
{{
    config(
        target_schema='snapshots',
        unique_key='CustomerId',
        strategy='timestamp',
        updated_at='UpdatedAt'
    )
}}

select
    *
from {{ source('raw', 'customers') }}
{% endsnapshot %}
