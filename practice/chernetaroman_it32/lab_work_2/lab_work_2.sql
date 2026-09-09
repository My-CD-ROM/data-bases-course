-- Завдання 1
SELECT id, type, duration_days, price
FROM memberships;


-- Завдання 2
SELECT type, duration_days, price
FROM memberships
WHERE price < 5000;


-- Завдання 3
SELECT id, type, price
FROM memberships
LIMIT 3;


-- Завдання 4
ALTER TABLE memberships
ADD COLUMN description TEXT;

INSERT INTO memberships
(type, duration_days, price, description)
VALUES
('Двотижневий', 14, 1000.00, NULL);

SELECT id, type, price, description
FROM memberships
WHERE description IS NULL;

SELECT id, type, price, description
FROM memberships
WHERE description IS NOT NULL;


-- Завдання 5
SELECT type, duration_days, price
FROM memberships
WHERE price > 1000 AND duration_days >= 30;
