{% macro grant_select(schema = target.schema , user = target.user) %}
    {% set query %}
        grant usage on schema {{ schema }} to {{ user }};
        grant select on all tables in schema {{ schema }} to {{ user }};
        -- grant select on all views in schema {{ schema }} to {{ user }};
    {% endset %}
    {{ log('Granting select on all tables and views in schema ' ~ schema ~ ' to ' ~ user, info=True) }}
    {% do run_query(query) %}
    {{ log('Privileges granted', info=True) }}
{% endmacro %}