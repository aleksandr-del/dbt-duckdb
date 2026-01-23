{% macro insert_log_records(schema_name, table_name) %}
    {% for result in results %}
        {% set query %}
            INSERT INTO {{ target.database}}.{{ schema_name }}.{{ table_name }} VALUES (
                '{{ invocation_id }}',
                '{{ result.node.unique_id }}',
                '{{ result.node.resource_type }}',
                '{{ result.status }}',
                {%- if result.timing %}
                '{{ result.timing[1].started_at }}',
                '{{ result.timing[1].completed_at }}'
                {%- else %}
                null,
                null
                {%- endif %}
            )
            {% endset %}
        {% do run_query(query) %}
    {% endfor %}
{% endmacro %}
