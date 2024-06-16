WITH base AS (
    SELECT fti.id,
           fti.departure_airport AS 출발공항,
           TO_CHAR(fti.departure_date, 'YYYY-MM-DD') AS 출발날짜,
           fti.arrival_airport AS 도착공항,
           TO_CHAR(fti.arrival_date, 'YYYY-MM-DD') AS 도착날짜,
           ftph.price AS 가격,
           ftph.ts,
           LAG(price) OVER (PARTITION BY ftph.id ORDER BY ts) AS 이전가격,
           CASE
               WHEN fti.is_roundtrip = true THEN '왕복'
               ELSE '편도'
           END AS 항공타입
    FROM flight_ticket_price_history ftph
    JOIN flight_ticket_info fti ON ftph.id = fti.id
),

calc AS (
    SELECT *,
           CASE
               WHEN 이전가격 IS NULL THEN NULL
               ELSE ("가격"::FLOAT - 이전가격) / 이전가격
           END AS 가격변동률
    FROM base
)

SELECT * FROM calc