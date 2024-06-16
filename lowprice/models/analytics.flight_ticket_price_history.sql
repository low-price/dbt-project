SELECT fti.id,
      fti.departure_airport || '-' || fti.arrival_airport AS 항공권,
      TO_CHAR(fti.departure_date, 'YYYY-MM-DD') AS 출발일,
      TO_CHAR(fti.arrival_date, 'YYYY-MM-DD') AS 도착일,
      ftph.price AS 가격,
      ftph.ts AS 일시,
      CASE
          WHEN fti.is_roundtrip = true THEN '왕복'
          ELSE '편도'
      END AS 항공타입
FROM flight_ticket_price_history ftph
JOIN flight_ticket_info fti ON ftph.id = fti.id
ORDER BY 항공권, 항공타입, 출발일, 도착일, 일시;