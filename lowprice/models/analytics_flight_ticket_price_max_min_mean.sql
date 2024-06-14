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
),

max_price_dates AS (
    SELECT
        f.id,
        f.price,
        f.ts AS max_price_date
    FROM
        flight_ticket_price_history f
    JOIN
        base b ON f.id = b.id
    WHERE
        f.price = b.max_price
),

min_price_dates AS (
    SELECT
        f.id,
        f.price,
        f.ts AS min_price_date
    FROM
        flight_ticket_price_history f
    JOIN
        base b ON f.id = b.id
    WHERE
        f.price = b.min_price
)

SELECT
    b.id,
    b.max_price,
    md.max_price_date::DATE AS max_price_date,
    b.min_price,
    mind.min_price_date::DATE AS min_price_date,
    b.mean_price
FROM
    base b
JOIN
    max_price_dates md ON b.id = md.id
JOIN
    min_price_dates mind ON b.id = mind.id;