-- Практична робота №15

-- Завдання 1. План до створення індексу
EXPLAIN QUERY PLAN
SELECT *
FROM membership_sales
WHERE client_id = 2;

-- Результат:
-- `--SCAN membership_sales


-- Завдання 2. Створення індексу
CREATE INDEX idx_sales_client
ON membership_sales(client_id);

-- План після створення індексу
EXPLAIN QUERY PLAN
SELECT *
FROM membership_sales
WHERE client_id = 2;

-- Результат:
-- `--SEARCH membership_sales USING INDEX idx_sales_client (client_id=?)


-- Завдання 3. План до складеного індексу
EXPLAIN QUERY PLAN
SELECT *
FROM membership_sales
WHERE membership_id = 3 AND client_id = 2;

-- Результат:
-- `--SEARCH membership_sales USING INDEX idx_sales_client (client_id=?)

-- Створення складеного індексу
CREATE INDEX idx_sales_membership_client
ON membership_sales(membership_id, client_id);

-- План після створення складеного індексу
EXPLAIN QUERY PLAN
SELECT *
FROM membership_sales
WHERE membership_id = 3 AND client_id = 2;

-- Результат:
-- `--SEARCH membership_sales USING INDEX idx_sales_membership_client (membership_id=? AND client_id=?)


-- Завдання 4. План до індексу дати
EXPLAIN QUERY PLAN
SELECT *
FROM membership_sales
ORDER BY purchase_date;

-- Результат:
-- |--SCAN membership_sales
-- `--USE TEMP B-TREE FOR ORDER BY

-- Створення індексу дати
CREATE INDEX idx_sales_purchase_date
ON membership_sales(purchase_date);

-- План після створення індексу
EXPLAIN QUERY PLAN
SELECT *
FROM membership_sales
ORDER BY purchase_date;

-- Результат:
-- `--SCAN membership_sales USING INDEX idx_sales_purchase_date


-- Завдання 5. Видалення індексу
DROP INDEX idx_sales_client;

-- Перевірка плану після видалення
EXPLAIN QUERY PLAN
SELECT *
FROM membership_sales
WHERE client_id = 2;

-- Результат:
-- `--SCAN membership_sales

-- Перевірка наявних індексів
SELECT name, tbl_name
FROM sqlite_master
WHERE type = 'index';

-- Результат:
-- sqlite_autoindex_clients_1|clients
-- idx_sales_membership_client|membership_sales
-- idx_sales_purchase_date|membership_sales