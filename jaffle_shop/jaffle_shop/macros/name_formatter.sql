{% macro name_formatter(name) %}
upper(substr({{ name }}, 1, 1)) || lower(substr({{ name }}, 2))
{% endmacro %}
