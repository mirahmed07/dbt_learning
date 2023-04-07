{% macro cents_to_dollars(columns_name, decimal_places=2) -%}
    round({{ columns_name }}/100, {{ decimal_places }})
{%- endmacro %}