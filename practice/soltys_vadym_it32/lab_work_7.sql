-- Практика 7. Запити з різними видами об'єднання таблиць у SQLite
-- Схема: orders (факт), products (вимір 1), clients (вимір 2)

-- Завдання 1. INNER JOIN факт + вимір 1 (замовлення з кількістю >= 2)
SELECT products.name AS товар, orders.order_date AS дата, orders.quantity AS кількість
FROM orders
JOIN products ON orders.product_id = products.id
WHERE orders.quantity >= 2
ORDER BY orders.order_date;
-- Результат (4 рядк.):
-- товар | дата | кількість
-- Футболка базова | 2026-09-01 | 2
-- Кросівки спортивні | 2026-09-05 | 2
-- Футболка базова | 2026-09-07 | 3
-- Куртка зимова | 2026-09-10 | 2

-- Завдання 2. INNER JOIN усіх трьох таблиць
SELECT products.name AS товар, clients.full_name AS клієнт, orders.order_date AS дата
FROM orders
JOIN products ON orders.product_id = products.id
JOIN clients  ON orders.client_id  = clients.id
ORDER BY orders.order_date;
-- Результат (10 рядк.):
-- товар | клієнт | дата
-- Футболка базова | Олена Ковальчук | 2026-09-01
-- Джинси класичні | Максим Гриценко | 2026-09-02
-- Куртка зимова | Олена Ковальчук | 2026-09-03
-- Сукня літня | Ірина Бондар | 2026-09-04
-- Кросівки спортивні | Андрій Кравець | 2026-09-05
-- Шапка вовняна | Максим Гриценко | 2026-09-06
-- Футболка базова | Наталія Шевчук | 2026-09-07
-- Джинси класичні | Ірина Бондар | 2026-09-08
-- Шапка вовняна | Олена Ковальчук | 2026-09-09
-- Куртка зимова | Андрій Кравець | 2026-09-10

-- Завдання 3а. LEFT JOIN: товари без замовлень
SELECT products.name AS товар_без_замовлень
FROM products
LEFT JOIN orders ON orders.product_id = products.id
WHERE orders.id IS NULL;
-- Результат (1 рядк.):
-- товар_без_замовлень
-- Шарф вовняний

-- Завдання 3б. LEFT JOIN: клієнти без замовлень
SELECT clients.full_name AS клієнт_без_замовлень
FROM clients
LEFT JOIN orders ON orders.client_id = clients.id
WHERE orders.id IS NULL;
-- Результат (1 рядк.):
-- клієнт_без_замовлень
-- Дмитро Литвин

-- Завдання 4а. CROSS JOIN (кома-синтаксис)
SELECT COUNT(*) FROM products, clients;
-- Результат (1 рядк.):
-- COUNT(*)
-- 42

-- Завдання 4б. Кількість товарів
SELECT COUNT(*) FROM products;
-- Результат (1 рядк.):
-- COUNT(*)
-- 7

-- Завдання 4в. Кількість клієнтів
SELECT COUNT(*) FROM clients;
-- Результат (1 рядк.):
-- COUNT(*)
-- 6
