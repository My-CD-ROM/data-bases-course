- Практика 20. Створення та застосування Views у PostgreSQL
-- Батури Каріни ІТ-31
-- Завдання 1. Подання-фільтр
CREATE VIEW expensive_products AS
SELECT id, name, category, price, stock_quantity
FROM products
WHERE price > 500;

SELECT * FROM expensive_products ORDER BY id;
-- Результат: виводяться лише товари з таблиці products, у яких price > 500
-- (колонка size прихована, показуються тільки обрані 5 колонок).

-- Завдання 2. Подання завжди актуальне
SELECT * FROM expensive_products ORDER BY id;
-- Результат ДО INSERT: початковий набір товарів із ціною > 500.

INSERT INTO products (name, category, size, price, stock_quantity)
VALUES ('Худі оверсайз', 'Одяг', 'L', 850.00, 5);

SELECT * FROM expensive_products ORDER BY id;
-- Результат ПІСЛЯ INSERT: запис 'Худі оверсайз' (850.00) одразу з'явився
-- у вибірці подання без жодних додаткових команд оновлення.
-- Завдання 3. Запис через просте подання
INSERT INTO expensive_products (name, category, price)
VALUES ('Пальто базове', 'Верхній одяг', 1200.00);

SELECT id, name, category, size, price, stock_quantity
FROM products
WHERE name = 'Пальто базове';
-- рядок успішно потрапив у products;
-- колонка size (якої немає у поданні і не передано в INSERT) отримала NULL;
-- колонка stock_quantity (не передана в INSERT) отримала DEFAULT 0.

-- Завдання 4
-- Результат: кількість уже враховує новий рядок ('Куртка зимова').
SELECT COUNT(*) AS matview_count FROM expensive_products_mat;
-- Результат: кількість на 1 менша — матеріалізоване подання ще зберігає
-- старий знімок і не бачить 'Куртка зимова'.
-- Оновлення знімка матеріалізованого подання:
REFRESH MATERIALIZED VIEW expensive_products_mat;
-- Перевірка ПІСЛЯ REFRESH MATERIALIZED VIEW:
SELECT COUNT(*) AS view_count FROM expensive_products;
SELECT COUNT(*) AS matview_count FROM expensive_products_mat;
-- Результат: тепер view_count і matview_count однакові — матеріалізоване
-- подання підхопило новий рядок саме після виконання REFRESH.
-- Завдання 5.
CREATE OR REPLACE VIEW expensive_products AS
SELECT id, name, category, price, stock_quantity, size
FROM products
WHERE price > 300;

SELECT * FROM expensive_products ORDER BY id;
-- Результат: подання оновлено без DROP VIEW — додано колонку size у кінець
-- списку та розширено умову фільтрації до price > 300.

-- Завдання 6. Які подання можна змінювати + WITH CHECK OPTION
-- 6.1. Подання з JOIN (orders + customers) і спроба INSERT через нього:
CREATE VIEW customer_orders_view AS
SELECT o.id AS order_id,
       c.first_name,
       c.last_name,
       c.email
FROM orders o
JOIN customers c ON c.id = o.customer_id;
INSERT INTO customer_orders_view (first_name, last_name, email)
VALUES ('Тест', 'Користувач', 'test@example.com');
-- ERROR:  вставити дані в подання "customer_orders_view" не можна

-- 6.2. Додавання WITH CHECK OPTION до простого подання expensive_products:
CREATE OR REPLACE VIEW expensive_products AS
SELECT id, name, category, price, stock_quantity, size
FROM products
WHERE price > 300
WITH CHECK OPTION;

-- Перший INSERT: рядок відповідає умові WHERE (price > 300) — проходить успішно
INSERT INTO expensive_products (name, category, price, stock_quantity, size)
VALUES ('Пальто тепле', 'Верхній одяг', 900.00, 4, 'M');
-- Другий INSERT: рядок НЕ відповідає умові WHERE (price = 120 <= 300) — помилка
INSERT INTO expensive_products (name, category, price, stock_quantity)
VALUES ('Шкарпетки бавовняні', 'Аксесуари', 120, 15);
-- ERROR:  новий рядок порушує параметр перевірки для подання "expensive_products"