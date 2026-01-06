
SELECT
    itm.orderitemsid AS OrderItemsId,
    itm.orderid AS OrderId,
    itm.productid AS ProductId
FROM {{ source('raw', 'orderitems') }} AS itm
