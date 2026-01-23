{% macro if_schema_exists(schema_name) %}
    {% if execute %}
        {% set query %}
            SELECT * FROM duckdb_schemas() WHERE schema_name = '{{ schema_name }}'
        {% endset %}
        {% set result = run_query(query).columns['schema_name'].values() %}
        {% if result %}
            {{ return(True) }}
        {% else %}
            {{ return(False) }}
        {% endif %}
    {% endif %}
{% endmacro %}
