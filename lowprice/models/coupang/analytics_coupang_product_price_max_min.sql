WITH base AS (
    SELECT id,
        MAX(price) AS max_price,
        MIN(price) AS min_price,
        AVG(price) AS mean_price
    FROM {{ ref('coupang_product_price_history') }}
    GROUP BY id
)

SELECT * FROM base