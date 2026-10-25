-- Практика 12. Сортування і фільтрація даних
-- Варіант 7: Фітнес-клуб
-- Структура бази даних не змінюється.

.headers on
.mode column

-- Завдання 1. Сортування продажів за датою у спадному порядку.
SELECT id, client_id, purchase_date, expiration_date
FROM membership_sales
ORDER BY purchase_date DESC;

-- Завдання 2. Сортування за клієнтом і датою.
SELECT id, client_id, purchase_date
FROM membership_sales
ORDER BY client_id ASC, purchase_date DESC;

-- Завдання 3. Три найновіші продажі.
SELECT id, membership_id, client_id, purchase_date
FROM membership_sales
ORDER BY purchase_date DESC
LIMIT 3;

-- Завдання 4а. Унікальні типи абонементів.
SELECT DISTINCT type
FROM memberships
ORDER BY type ASC;

-- Завдання 4б. Абонементи вартістю від 500 до 3000 включно.
SELECT type, price
FROM memberships
WHERE price BETWEEN 500 AND 3000
ORDER BY price ASC;

-- Завдання 5а. Пошук прізвищ із великої літери М.
SELECT id, last_name, first_name
FROM clients
WHERE last_name LIKE 'Мельник%';

-- Завдання 5б. Пошук того самого прізвища з малої літери м.
SELECT id, last_name, first_name
FROM clients
WHERE last_name LIKE 'мельник%';
