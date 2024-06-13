WITH base AS (
    SELECT id,
           MAX(price) AS max_price,
           MIN(price) AS min_price,
           ROUND(AVG(price))::INTEGER AS mean_price
    FROM flight_ticket_price_history
    GROUP BY id
)

SELECT * FROM base