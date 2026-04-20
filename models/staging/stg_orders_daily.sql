
  {{
      config(
          materialized = 'view'
      )
  }}

  with orders as (
      select * from {{ ref('stg_orders') }}
  ),

  daily as (
      select
          cast(date_trunc('day', ordered_at) as date) as order_date,
          count(*) as orders_count,
          count(distinct customer_id) as unique_customers,
          sum(order_total) as total_revenue,
          sum(tax_paid) as total_tax
      from orders
      group by 1
  )

  select *
  from daily
  order by order_date