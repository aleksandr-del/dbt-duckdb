{{
    config(
        materialized='view'
    )
}}


SELECT 
    ord.orderid AS OrderId,
    ord.customerid AS CustomerId,
    ([upper(x[1]) || lower(x[2:]) for x in str_split(ord.salesperson, ' ')])
    .list_aggr('string_agg', ' ') AS SalesPerson,
     cast(ord.ORDERPLACEDTIMESTAMP AS timestamp) AS OrderPlacedTimestamp,
    ord.ORDERSTATUS OrderStatus,
    cast(ord.UPDATEDAT AS timestamp) AS UpdatedAt
FROM {{ source('raw', 'orders') }} AS ord
