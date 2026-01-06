
SELECT
    pro.PRODUCTID AS ProductId,
    pro.PRODUCT AS Product,
    pro.PRICE AS Price,
    pro.DEPARTMENT AS Department,
    pro.CREATEDAT AS CreatedAt,
    pro.UPDATEDAT AS UpdatedAt
FROM {{ source('raw', 'products') }} AS pro
