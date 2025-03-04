with orders as  (
    select * from {{ ref ('stg_jaffle_shop__orders' )}}
),

payments as (
    select * from {{ ref ('stg_stripe__payments') }}
),

successful_payments as (
    select
        order_id,
        sum (case when status = 'success' then amount end) as amount

    from payments
    group by 1
),
    
 final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce (successful_payments.amount, 0) as amount

    from orders
    left join successful_payments using (order_id)
)
select *
from final
