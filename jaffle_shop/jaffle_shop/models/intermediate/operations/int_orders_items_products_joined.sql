{{
    config(
        materialized='table'
    )
}}


SELECT
    itm.OrderItemsId,
    itm.OrderId,
    pro.Product,
    pro.Department,
    pro.Price
FROM {{ ref('stg_furniture_mart_orderitems') }} AS itm
JOIN {{ ref('stg_furniture_mart_products') }} AS pro 
    USING(ProductId)
