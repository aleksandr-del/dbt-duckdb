{{ env_var('PYTHON_VERSION') }}

{{ adapter.get_columns_in_relation(source('raw', 'customers')) | map(attribute='name') | list }}

{# These are literal expressions #}
{{ 'This compiles to a string' }}
{{ 100 }}
{{ ['this', 'is', 'a', 'list'] }}

{# These are math expressions #}
{{ 7 + 23 }}
{{ 79 - 37 }}
{{ 5 * 55 }}

{# These are comparison expressions #}
{{ 1 == 1 }}
{{ 1 != 1 }}
{{ 2 > 1 }}
{{ 2 < 1 }}

{# Setting variables #}
{%- set foo = 'bar' %}
{{ foo }}

{%- set foo = 'bar' %}
{%- set foo = 'baz' %}
{{ foo }}

{# Assignment block #}
{%- set foo %}
'This is an assignment block'
{%- endset %}
{{ foo }}

{# Conditional statements #}
{%- set foo = 'bar' %}
{%- if foo == 'baz' %}
    'This condition is checked first'
{%- elif foo == 'bar' %}
    'This condition is true'
{%- else %}
    'This is true only if the above are false'
{%- endif %}

{# Loop statements #}
{%- set fruits = ['apple', 'banana', 'peach'] %}
{%- for fruit in fruits %}
    The current fruit is {{ fruit }}{% if not loop.last %};{% else %}.{% endif %}
{%- endfor %}

{# Filters #}
{{ fruits | join(', ') }}

{%- set foo = 'bar' %}
{{ foo | reverse }}

{#- Whitespace control #}
{%- set var = 'Will there be a whitespace here!' %}
{#- Will this comment leave a whitespace? #}
{%- for i in range(1) %}
    'How many whitespaces will this loop leave?'
{%- endfor %}
