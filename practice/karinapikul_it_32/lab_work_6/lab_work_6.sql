-- Практична робота №6

-- Завдання 1. UPDATE у фактовій таблиці
UPDATE membership_sales
SET expiration_date = '2026-10-10'
WHERE id = 7;

-- Перевірка
SELECT * FROM membership_sales
WHERE id = 7;


-- Завдання 2. UPDATE у таблиці-вимірі
UPDATE memberships
SET price = 200
WHERE id = 1;

-- Перевірка
SELECT * FROM memberships
WHERE id = 1;


-- Завдання 3. DELETE одного рядка
SELECT COUNT(*) FROM membership_sales;

DELETE FROM membership_sales
WHERE id = 10;

SELECT COUNT(*) FROM membership_sales;


-- Завдання 4. 
Перевірка ON DELETE RESTRICT

PRAGMA foreign_keys = ON;

-- Спроба видалити абонемент, на який є посилання
DELETE FROM memberships
WHERE id = 2;

-- Перевірка, що абонемент залишився
SELECT * FROM memberships
WHERE id = 2;


Перевірка ON DELETE CASCADE

-- Спроба видалення клієнта id = 1
DELETE FROM clients
WHERE id = 1;

-- Перевірка пов'язаних записів
SELECT * FROM membership_sales
WHERE client_id = 1;