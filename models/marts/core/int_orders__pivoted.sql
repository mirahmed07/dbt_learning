-- {%- set payment_methods = ['bank_transfer', 'credit_card', 'coupon', 'gift_card'] -%}
{%- set payment_methods = dbt_utils.get_column_values(table=ref('stg_payments'), column='payment_method') -%}

with payments as (
    select * from {{ ref('stg_payments') }}
),

-- pivoted as (
--     select order_id,
--     sum(case when payment_method = 'bank_transfer' then amount else 0 end) as bank_transfer_amount,
--     sum(case when payment_method = 'credit_card' then amount else 0 end) as credit_card_amount,
--     sum(case when payment_method = 'coupon' then amount else 0 end) as coupon_amount,
--     sum(case when payment_method = 'gift_card' then amount else 0 end) as gift_card_amount
--     from payments
--     where status = 'success'
--     group by 1
-- )
pivoted as (
    select order_id,
    {% for payment_method in payment_methods -%}
        {%- if not loop.last -%}
            sum(case when payment_method = '{{ payment_method }}' then amount else 0 end) as {{ payment_method }}_amount,
        {%- else -%}
            sum(case when payment_method = '{{ payment_method }}' then amount else 0 end) as {{ payment_method }}_amount
        {%- endif %}
    {% endfor -%}
    from payments
    where status = 'success'
    group by 1
)
select * from pivoted