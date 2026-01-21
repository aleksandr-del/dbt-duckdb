{%- set statuses = ['placed', 'shipped', 'returned'] %}

SELECT
    CAST(OrderPlacedTimestamp AS date) AS OrderDate,
    {%- for status in statuses %}
    COUNT(DISTINCT CASE WHEN OrderStatus = '{{ status }}' THEN OrderId END) AS TotalOrders{{ status | capitalize }}{% if not loop.last %},{% endif %}
    {%- endfor %}
FROM {{ ref('fct_revenue_orders_python') }}
GROUP BY 1
