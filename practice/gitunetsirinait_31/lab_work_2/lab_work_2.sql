SELECT type, status, price_per_night
FROM rooms;

SELECT type, price_per_night
FROM rooms
WHERE price_per_night > 2000;

SELECT type, price_per _night, capacity
FROM rooms
LIMIT 3;

SELECT type, status FROM rooms WHERE status IS NULL;
SELECT type, status FROM rooms WHERE status IS NOT NULL;|

SELECT type, price_per_night, capacity, status FROM rooms
WHERE capacity >= 2 AND price_per_night < 3000;