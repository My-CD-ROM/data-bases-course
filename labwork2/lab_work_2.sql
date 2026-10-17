SELECT type, price_per_night, capacity 
FROM rooms;

SELECT type, price_per_night, status 
FROM rooms 
WHERE price_per_night <= 3000.00;

SELECT * 
FROM rooms 
LIMIT 3;

SELECT type, price_per_night 
FROM rooms 
WHERE status IS NULL;

SELECT type, price_per_night 
FROM rooms 
WHERE status IS NOT NULL;

SELECT type, price_per_night, capacity, status 
FROM rooms 
WHERE capacity >= 2 AND price_per_night < 4000.00;