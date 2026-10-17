-- Практика 8. Агрегатні функції (варіант 2, інтернет-магазин одягу)

-- Завдання 1. COUNT(*) проти COUNT(колонка)
-- У orders колонка client_id необов'язкова: у замовленнях 4 і 8 вона NULL
-- (після ON DELETE SET NULL у Практиці 6), тому додатковий UPDATE не потрібен.
SELECT COUNT(*) AS total_orders, COUNT(client_id) AS orders_with_client FROM orders;
-- Результат: 9 | 7

-- Завдання 2. SUM і AVG на числовій колонці
SELECT SUM(quantity) AS total_items, AVG(quantity) AS avg_items_per_order FROM orders;
-- Результат: 14 | 1.5555555555555556

-- Завдання 3. MIN/MAX на текстових колонках
SELECT MIN(order_date) AS first_order, MAX(order_date) AS last_order FROM orders;
-- Результат: 2026-09-01 | 2026-09-09
SELECT MIN(full_name) AS first_by_alphabet, MAX(full_name) AS last_by_alphabet FROM clients;
-- Результат: Андрій Кравець | Олена Ковальчук

-- Завдання 4. Кілька агрегатних функцій в одному запиті
SELECT COUNT(*)        AS total_orders,
       COUNT(client_id) AS orders_with_client,
       SUM(quantity)   AS total_items,
       AVG(quantity)   AS avg_items,
       MIN(quantity)   AS min_items,
       MAX(quantity)   AS max_items
FROM orders;
-- Результат: 9 | 7 | 14 | 1.5555555555555556 | 1 | 3

-- Завдання 5. Той самий звіт + WHERE за категорією з таблиці-виміру products
SELECT COUNT(*)          AS total_orders,
       COUNT(o.client_id) AS orders_with_client,
       SUM(o.quantity)   AS total_items,
       AVG(o.quantity)   AS avg_items,
       MIN(o.quantity)   AS min_items,
       MAX(o.quantity)   AS max_items
FROM orders o
JOIN products p ON p.id = o.product_id
WHERE p.category = 'Аксесуари';
-- Результат: 2 | 2 | 2 | 1.0 | 1 | 1

-- Контрольне питання 3. SUM, коли всі значення NULL (замовлення без клієнта)
SELECT SUM(client_id) AS sum_client, AVG(client_id) AS avg_client,
       COUNT(client_id) AS cnt_client, COUNT(*) AS cnt_all
FROM orders WHERE client_id IS NULL;
-- Результат: NULL | NULL | 0 | 2
