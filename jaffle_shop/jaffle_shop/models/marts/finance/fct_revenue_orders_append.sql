{{
    config(
        materialized='incremental',
        incremental_strategy='append',
    )
}}

{%- if is_incremental() %}
    {%- set query %}
        SELECT max(OrderId) FROM {{ this }}
    {%- endset %}
    {%- if execute %}
        {%- set max_order_id = run_query(query).columns[0][0] %}
    {%- endif %}
{%- endif %}

WITH cte AS (
    SELECT
    pro.OrderId,
    sum(pro.Price)::numeric(10, 2) as Revenue
    FROM {{ ref('int_orders_items_products_joined') }} AS pro
    GROUP BY 1
)

SELECT
    ord.OrderId,
    ord.OrderPlacedTimestamp,
    ord.UpdatedAt,
    ord.OrderStatus,
    ord.SalesPerson,
    cte.Revenue
FROM cte
JOIN {{ ref('stg_furniture_mart_orders') }} ord
    USING (OrderId)
WHERE
    1 = 1
{% if is_incremental() %}
    AND ord.OrderId > {{ var('backfill_order_id', max_order_id) }}
    AND ord.OrderId <= ({{ var('backfill_order_id', max_order_id) }} + 10)
{% else %}
    AND ord.OrderId = (SELECT min(OrderId) FROM {{ ref('int_orders_items_products_joined') }})
{% endif %}
