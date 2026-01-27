{% test is_greater(model, column_name, value) %}
select
    1
from {{ model }}
where {{ column_name }} <= {{ value }}
{% endtest %}
