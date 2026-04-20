{{
    config(
        materialized = 'view'
    )
}}

with orders as (
    select * from {{ ref('stg_orders') }}
),

weekly as (
    select
        cast(date_trunc('week', ordered_at) as date) as order_week,
        count(*) as orders_count,
        count(distinct customer_id) as unique_customers,
        sum(order_total) as total_revenue,
        sum(tax_paid) as total_tax,
        avg(order_total) as avg_order_value
    from orders
    group by 1
)

select *
from weekly
order by order_week
