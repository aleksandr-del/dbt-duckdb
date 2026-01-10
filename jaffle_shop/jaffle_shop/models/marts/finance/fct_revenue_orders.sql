{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='OrderId',
    )
}}

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
    AND ord.OrderId BETWEEN (SELECT max(OrderId) FROM {{ this }}) and (SELECT max(OrderId) + 5 FROM {{ this }})
{% else %}
    AND ord.OrderId = (SELECT min(OrderId) FROM {{ ref('int_orders_items_products_joined') }})
{% endif %}
