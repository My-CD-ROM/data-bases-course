-- Практика 12. Сортування і фільтрація (варіант 2, інтернет-магазин одягу)

-- Завдання 1. ORDER BY за однією колонкою (за спаданням)
SELECT * FROM orders ORDER BY order_date DESC;
-- Результат (id): 9, 8, 7, 6, 5, 4, 3, 2, 1  — першим іде замовлення 9 (2026-09-09)

-- Завдання 2. ORDER BY за двома колонками
SELECT id, product_id, quantity, order_date
FROM orders
ORDER BY quantity DESC, order_date ASC;
-- Результат (id): 7(3), 1(2), 4(2), 5(2), 2(1), 3(1), 6(1), 8(1), 9(1)

-- Завдання 3. Топ-3 найновіших замовлень
SELECT id, product_id, order_date
FROM orders
ORDER BY order_date DESC
LIMIT 3;
-- Результат: (9, 6, 2026-09-09) (8, 2, 2026-09-08) (7, 1, 2026-09-07)
-- Для порівняння, LIMIT без ORDER BY:
SELECT id, product_id, order_date FROM orders LIMIT 3;
-- Результат: (1, 1, 2026-09-01) (2, 2, 2026-09-02) (3, 3, 2026-09-03)

-- Завдання 4 (а). DISTINCT
SELECT DISTINCT category FROM products;
-- Результат: Футболки, Джинси, Куртки, Сукні, Взуття, Аксесуари  (6 унікальних із 8 рядків)

-- Завдання 4 (б). BETWEEN
SELECT name, price FROM products WHERE price BETWEEN 200 AND 900 ORDER BY price;
-- Результат: Шарф вовняний 220 ; Шапка вовняна 250 ; Футболка базова 299 (×2, id 1 і 8) ;
--            Сукня літня 650 ; Джинси класичні 899
-- Для порівняння, IN:
SELECT name, category FROM products WHERE category IN ('Куртки', 'Взуття', 'Аксесуари');
-- Результат: Куртка зимова ; Кросівки спортивні ; Шапка вовняна ; Шарф вовняний

-- Завдання 5. LIKE і регістр кирилиці
SELECT full_name FROM clients WHERE full_name LIKE 'Олена%';   -- 1 рядок: Олена Ковальчук
SELECT full_name FROM clients WHERE full_name LIKE 'олена%';   -- 0 рядків
SELECT name FROM products WHERE name LIKE 'Ш%';                -- 2 рядки: Шапка вовняна, Шарф вовняний
SELECT name FROM products WHERE name LIKE 'ш%';                -- 0 рядків
SELECT 'Abc' LIKE 'abc', 'Олена' LIKE 'олена';                 -- 1 | 0  (латиниця ігнорує регістр, кирилиця ні)
