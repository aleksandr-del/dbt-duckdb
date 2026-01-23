{% macro create_logs_table(schema_name, table_name) %}
{% if not if_schema_exists(schema_name) %}
    {% do adapter.create_schema(api.Relation.create(database=target.database, schema=schema_name)) %}
{% endif %}
    CREATE TABLE IF NOT EXISTS {{ target.database }}.{{ schema_name }}.{{ table_name }} (
        invocation_id VARCHAR,
        node_unique_id VARCHAR,
        node_type VARCHAR,
        result_status VARCHAR,
        started_at TIMESTAMP,
        completed_at TIMESTAMP
    )
{% endmacro %}
