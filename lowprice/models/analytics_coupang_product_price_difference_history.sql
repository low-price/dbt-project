WITH base AS (
    SELECT *,
        LAG(price) OVER (PARTITION BY id ORDER BY datetime) AS prev_price
    FROM coupang_product_price_history
),

calc AS (
    SELECT *,
        CASE
            WHEN prev_price IS NULL THEN NULL
            ELSE (price - prev_price) / prev_price
        END AS price_change_rate
    FROM base
)

SELECT * FROM calc