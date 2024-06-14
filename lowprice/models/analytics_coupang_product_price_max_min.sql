WITH base AS (
    SELECT id,
        MAX(price) AS max_price,
        MIN(price) AS min_price,
        AVG(price) AS mean_price
    FROM coupang_product_price_history
    GROUP BY id
)

SELECT base.*, coupang_product_info.product_name
FROM base
JOIN coupang_product_info ON base.id = coupang_product_info.id