SELECT id, datetime
FROM coupang_product_price_history
GROUP BY id, datetime
HAVING COUNT(*) > 1