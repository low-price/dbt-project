SELECT *
FROM {{ ref('coupang_product_price_history') }}
WHERE price < 0