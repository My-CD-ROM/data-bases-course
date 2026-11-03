-- Практика 9. Групування даних (варіант 2, інтернет-магазин одягу)

-- Завдання 1. GROUP BY за зовнішнім ключем
SELECT product_id, COUNT(*) AS orders_count
FROM orders
GROUP BY product_id;
-- Результат: (1,2) (2,2) (3,1) (4,1) (5,1) (6,2)

-- Завдання 2. Назва товару замість id (LEFT JOIN + GROUP BY за первинним ключем p.id)
SELECT p.name, COUNT(o.id) AS orders_count
FROM products p
LEFT JOIN orders o ON o.product_id = p.id
GROUP BY p.id;
-- Результат: Футболка базова 2 | Джинси класичні 2 | Куртка зимова 1 | Сукня літня 1
--            Кросівки спортивні 1 | Шапка вовняна 2 | Шарф вовняний 0

-- Завдання 3. Кілька агрегатів у групі
SELECT p.name,
       COUNT(o.id)      AS orders_count,
       SUM(o.quantity)  AS total_items,
       AVG(o.quantity)  AS avg_items
FROM products p
LEFT JOIN orders o ON o.product_id = p.id
GROUP BY p.id;
-- Результат: Футболка базова 2|5|2.5 ; Джинси 2|2|1.0 ; Куртка 1|1|1.0 ; Сукня 1|2|2.0
--            Кросівки 1|2|2.0 ; Шапка 2|2|1.0 ; Шарф 0|NULL|NULL

-- Завдання 4. GROUP BY за двома колонками
SELECT product_id, quantity, COUNT(*) AS orders_count
FROM orders
GROUP BY product_id, quantity;
-- Результат: 7 рядків: (1,2,1) (1,3,1) (2,1,2) (3,1,1) (4,2,1) (5,2,1) (6,1,2)
SELECT COUNT(DISTINCT product_id) AS products_in_orders, COUNT(DISTINCT quantity) AS quantities FROM orders;
-- Результат: 6 | 3

-- Завдання 5. Колонка поза GROUP BY (order_date не в GROUP BY і не під агрегатом)
SELECT product_id, order_date, COUNT(*) AS orders_count
FROM orders
GROUP BY product_id;
-- Запуск 1 і запуск 2: (1,'2026-09-01',2) (2,'2026-09-02',2) (3,'2026-09-03',1)
--                      (4,'2026-09-04',1) (5,'2026-09-05',1) (6,'2026-09-06',2)

-- Контрольне питання 2. INNER JOIN замість LEFT JOIN
SELECT p.name, COUNT(o.id) AS orders_count
FROM products p
INNER JOIN orders o ON o.product_id = p.id
GROUP BY p.id;
-- Результат: 6 рядків, «Шарф вовняний» зникає
