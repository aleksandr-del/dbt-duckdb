{{
    config(
        materialized="table"
    )
}}


select 
    oi.orderid,
    count(1) as total_items,
    sum(p.price) as total_sum
from {{ source("raw", "orderitems") }}  as oi
join {{ source("raw", "products") }} as p using (productid)
where oi.orderid = 811
group by 1
