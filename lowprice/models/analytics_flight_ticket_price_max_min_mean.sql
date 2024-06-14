WITH base AS (
    SELECT fti.id,
           fti.departure_airport || '-' || fti.arrival_airport AS airport,
           MAX(price) AS max_price,
           MIN(price) AS min_price,
           ROUND(AVG(price))::INTEGER AS mean_price
    FROM flight_ticket_price_history ftph
    JOIN flight_ticket_info fti
        ON ftph.id = fti.id
    GROUP BY fti.id, airport
)

SELECT * FROM base