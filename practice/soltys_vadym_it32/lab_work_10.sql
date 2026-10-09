-- Практика 10. HAVING (варіант 2, інтернет-магазин одягу)

-- Завдання 1. HAVING на COUNT: товари, які замовляли більше 1 разу
SELECT product_id, COUNT(*) AS orders_count
FROM orders
GROUP BY product_id
HAVING COUNT(*) > 1;
-- Результат: (1,2) (2,2) (6,2)

-- Завдання 2. HAVING на MAX: категорії, де найдорожчий товар коштує менше 1000
SELECT category, MAX(price) AS max_price
FROM products
GROUP BY category
HAVING MAX(price) < 1000;
-- Результат: Аксесуари 250.0 | Джинси 899.0 | Сукні 650.0 | Футболки 299.0

-- Завдання 3. WHERE + GROUP BY + HAVING
SELECT product_id, SUM(quantity) AS total_items
FROM orders
WHERE client_id IS NOT NULL
GROUP BY product_id
HAVING SUM(quantity) >= 2;
-- Результат: (1,5) (5,2) (6,2)

-- Завдання 4. Свідома помилка: агрегат у WHERE
SELECT product_id, COUNT(*)
FROM orders
WHERE COUNT(*) > 1
GROUP BY product_id;
-- Помилка SQLite: misuse of aggregate: COUNT()

-- Завдання 5. LEFT JOIN + GROUP BY + HAVING: товари з менш ніж 2 замовленнями (включно з 0)
SELECT p.name, COUNT(o.id) AS orders_count
FROM products p
LEFT JOIN orders o ON o.product_id = p.id
GROUP BY p.id
HAVING COUNT(o.id) < 2;
-- Результат: Куртка зимова 1 | Сукня літня 1 | Кросівки спортивні 1 | Шарф вовняний 0

-- Контрольне питання 2. Те саме з INNER JOIN
SELECT p.name, COUNT(o.id) AS orders_count
FROM products p
INNER JOIN orders o ON o.product_id = p.id
GROUP BY p.id
HAVING COUNT(o.id) < 2;
-- Результат: 3 рядки, «Шарф вовняний» зникає
