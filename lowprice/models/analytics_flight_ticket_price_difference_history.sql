WITH base AS (
    SELECT fti.id,
           fti.departure_airport,
           fti.departure_date,
           fti.arrival_airport,
           fti.arrival_date,
           ftph.price,
        LAG(price) OVER (PARTITION BY id ORDER BY ts) AS prev_price
    FROM flight_ticket_price_history ftph
    JOIN flight_ticket_info fti
        ON ftph.id = fti.id
),

calc AS (
    SELECT *,
           CASE
               WHEN prev_price IS NULL THEN NULL
               ELSE (price::FLOAT - prev_price) / prev_price
           END AS price_change_rate
    FROM base
)

SELECT * FROM calc