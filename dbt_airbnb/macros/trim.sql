{% macro trim(col) %}
    {{ col | trim | upper }}
{% endmacro %}