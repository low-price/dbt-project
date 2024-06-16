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
        f.ts AS max_price_date,
        (departure_duration + COALESCE(arrival_duration, INTERVAL '0 minutes')) AS total_duration,
        TO_CHAR(departure_date, 'YYYY-MM-DD') || '~' || TO_CHAR(COALESCE(arrival_date, departure_date), 'YYYY-MM-DD') AS "출발일~도착일",
        ROW_NUMBER() OVER (PARTITION BY f.id ORDER BY price DESC, ts DESC) AS row_number
    FROM
        flight_ticket_price_history f
    JOIN base b ON f.id = b.id
    JOIN flight_ticket_info i ON i.id = b.id
    WHERE
        f.price = b.max_price
),

min_price_dates AS (
    SELECT
        f.id,
        f.price,
        f.ts AS min_price_date,
        ROW_NUMBER() OVER (PARTITION BY f.id ORDER BY price, ts DESC) AS row_number
    FROM
        flight_ticket_price_history f
    JOIN
        base b ON f.id = b.id
    WHERE
        f.price = b.min_price
)

SELECT
    b.id,
    b.airport as "항공권",
    md."출발일~도착일",
    b.max_price as "최고가",
    md.max_price_date::DATE AS "최고가 날짜",
    b.min_price as "최저가",
    mind.min_price_date::DATE AS "최저가 날짜",
    b.mean_price as "평균가",
    md.total_duration AS "총소요시간",
    CASE
        WHEN i.is_roundtrip = True THEN '왕복'
        ELSE '편도'
    END AS "항공타입"
FROM base b
JOIN flight_ticket_info i ON b.id = i.id
JOIN max_price_dates md ON b.id = md.id AND md.row_number = 1
JOIN min_price_dates mind ON b.id = mind.id AND mind.row_number = 1
ORDER BY "항공타입", max_price, min_price;