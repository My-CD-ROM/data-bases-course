-- Завдання 1
SELECT type, duration_days, price
FROM memberships;

-- Завдання 2
SELECT type, price
FROM memberships
WHERE price < 5000;

-- Завдання 3
SELECT *
FROM memberships
LIMIT 3;

-- Завдання 4
SELECT *
FROM memberships
WHERE description IS NULL;

SELECT *
FROM memberships
WHERE description IS NOT NULL;

-- Завдання 5
SELECT type, duration_days, price, description
FROM memberships
WHERE (duration_days <= 30 OR duration_days = 180) AND (price < 1000 OR price = 5200.0);
