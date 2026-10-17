PRAGMA foreign_keys = ON;

-- Завдання 1

UPDATE membership_sales
SET expiration_date = '2026-10-10'
WHERE id = 1;


-- Завдання 2

UPDATE memberships
SET price = 1600
WHERE id = 2;


-- Завдання 3

SELECT COUNT(*) AS count_before
FROM membership_sales;

DELETE FROM membership_sales
WHERE id = 10;

SELECT COUNT(*) AS count_after
FROM membership_sales;


-- Завдання 4

DELETE FROM memberships
WHERE id = 1;

SELECT *
FROM membership_sales
WHERE membership_id = 1;
