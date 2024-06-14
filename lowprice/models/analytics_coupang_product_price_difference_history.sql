WITH base AS (
    SELECT *,
        LAG(price) OVER (PARTITION BY id ORDER BY datetime) AS prev_price
    FROM coupang_product_price_history
),

calc AS (
    SELECT *,
        CASE
            WHEN prev_price IS NULL THEN NULL
            ELSE ROUND((CAST(price AS FLOAT) - prev_price) / prev_price, 3)
        END AS price_change_rate
    FROM base
)

SELECT calc.*, coupang_product_info.product_name
FROM calc
JOIN coupang_product_info ON calc.id = coupang_product_info.id