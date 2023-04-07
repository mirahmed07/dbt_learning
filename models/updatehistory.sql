{{ config (
    materialized="view"
)}}
with final as (
SELECT
TRIM(nspname) AS schema_name,
TRIM(relname) AS table_name,
relcreationtime AS creation_time,
case when nspname not in ('analytics', 'dbt_mahmed') then 'source'
when relcreationtime is null then 'view'
else 'table' end as relationtype
FROM pg_class_info
LEFT JOIN pg_namespace ON pg_class_info.relnamespace = pg_namespace.oid
WHERE reltype != 0
AND TRIM(nspname) in ('dbt_mahmed', 'analytics', 'jaffle_shop', 'stripe')
order by 1,2
)
select * from final
