PRAGMA foreign_keys = ON;

-- Завдання 1
-- Оновлюємо дату завершення абонемента для одного продажу
UPDATE membership_sales
SET expiration_date = '2026-10-15'
WHERE id = 1;

SELECT *
FROM membership_sales
WHERE id = 1;


-- Завдання 2
-- Оновлюємо ціну одного абонемента
UPDATE memberships
SET price = 1200
WHERE id = 1;

SELECT *
FROM memberships
WHERE id = 1;


-- Завдання 3
-- Перевіряємо кількість записів перед видаленням
SELECT COUNT() AS count_before
FROM membership_sales;

-- Видаляємо один конкретний продаж
DELETE FROM membership_sales
WHERE id = 10;

-- Перевіряємо кількість після видалення
SELECT COUNT() AS count_after
FROM membership_sales;


-- Завдання 4
-- Перевіряємо ON DELETE CASCADE
SELECT *
FROM membership_sales
WHERE client_id = 1;

-- Видаляємо клієнта
DELETE FROM clients
WHERE id = 1;

-- Перевіряємо, чи видалились пов'язані продажі
SELECT *
FROM membership_sales
WHERE client_id = 1;

SELECT *
FROM clients
WHERE id = 1;