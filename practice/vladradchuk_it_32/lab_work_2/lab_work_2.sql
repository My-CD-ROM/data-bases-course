-- Практична робота №2
-- Варіант 2
-- Завдання 1

SELECT id, name, price, stock_quantity
FROM products;

-- Завдання 2

SELECT name, price
FROM products
WHERE price < 2000;

-- Завдання 3

SELECT id, name, price
FROM products
LIMIT 3;

-- Завдання 4

INSERT INTO products (name, category, size, price, stock_quantity)
VALUES ('Спортивна футболка', 'Футболки', NULL, 799.00, 10);

SELECT id, name, size
FROM products
WHERE size IS NULL;

SELECT id, name, size
FROM products
WHERE size IS NOT NULL;

-- Завдання 5
SELECT name, price, stock_quantity
FROM products
WHERE price < 2000 AND stock_quantity > 0;

-- Контрольні питання

-- 1. Чому WHERE price = NULL повертає порожній результат?
-- NULL означає відсутність або невідоме значення.
-- Тому NULL не можна порівнювати за допомогою =.
-- Для перевірки потрібно використовувати IS NULL або IS NOT NULL.

-- 2. Чим WHERE відрізняється від HAVING?
-- WHERE фільтрує окремі рядки таблиці до групування.
-- HAVING фільтрує вже сформовані групи після GROUP BY.

-- 3. Коли варто уникати SELECT * і чому?
-- SELECT * варто уникати, коли потрібні лише конкретні стовпці.
-- Краще явно вказувати потрібні стовпці, щоб не отримувати зайві дані
-- та зробити результат запиту зрозумілішим.
