{{ env_var('PYTHON_VERSION') }}

{{ adapter.get_columns_in_relation(source('raw', 'customers')) | map(attribute='name') | list }}
