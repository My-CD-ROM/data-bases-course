-- Практика 20. Views та Materialized Views у PostgreSQL
-- Варіант 2, інтернет-магазин одягу. База: clothing_store_db (стан після практики 19)
-- Виконувати у Query Tool по одній команді (виділити й натиснути F5).

-- Завдання 1
CREATE VIEW products_low_stock AS
SELECT id, name, category, price
FROM products
WHERE stock_quantity BETWEEN 1 AND 9;
SELECT * FROM products_low_stock ORDER BY id;
-- Результат (6 рядків), id | name | price:
-- 3 Куртка зимова 2499; 13 Пальто осіннє 3200; 19 Шарф кашеміровий 1450;
-- 22 Жилет утеплений 1190; 24 Чоботи шкіряні 3400; 25 Жилет джинсовий 960

-- Завдання 2
SELECT COUNT(*) FROM products_low_stock;
-- До INSERT: 6
INSERT INTO products (name, category, size, price, stock_quantity)
VALUES ('Парка зимова', 'Куртки', 'XL', 2750, 3);
SELECT * FROM products_low_stock ORDER BY id;
-- Після INSERT: 7 рядків, з'явився 26 | Парка зимова | Куртки | 2750

-- Завдання 3
INSERT INTO products_low_stock (name, category, price)
VALUES ('Ремінь шкіряний', 'Аксесуари', 480);
SELECT * FROM products WHERE name = 'Ремінь шкіряний';
-- Результат: id=27, size=NULL, price=480, stock_quantity=0, price_with_vat=576, low_stock=t
SELECT * FROM products_low_stock WHERE name = 'Ремінь шкіряний';
-- Результат: 0 рядків

-- Завдання 4
CREATE MATERIALIZED VIEW products_low_stock_mat AS
SELECT id, name, category, price
FROM products
WHERE stock_quantity BETWEEN 1 AND 9;
SELECT (SELECT COUNT(*) FROM products_low_stock) AS view_count,
       (SELECT COUNT(*) FROM products_low_stock_mat) AS mat_count;
-- Одразу після створення: view_count = 7, mat_count = 7
INSERT INTO products (name, category, size, price, stock_quantity)
VALUES ('Плащ демісезонний', 'Пальто', 'M', 2100, 2);
SELECT (SELECT COUNT(*) FROM products_low_stock) AS view_count,
       (SELECT COUNT(*) FROM products_low_stock_mat) AS mat_count;
-- Після INSERT, до REFRESH: view_count = 8, mat_count = 7
REFRESH MATERIALIZED VIEW products_low_stock_mat;
SELECT (SELECT COUNT(*) FROM products_low_stock) AS view_count,
       (SELECT COUNT(*) FROM products_low_stock_mat) AS mat_count;
-- Після REFRESH: view_count = 8, mat_count = 8

-- Завдання 5
CREATE OR REPLACE VIEW products_low_stock AS
SELECT id, name, category, price, stock_quantity
FROM products
WHERE stock_quantity BETWEEN 1 AND 9;
SELECT * FROM products_low_stock ORDER BY id;
-- Результат (8 рядків), id | name | stock_quantity:
-- 3 Куртка зимова 6; 13 Пальто осіннє 6; 19 Шарф кашеміровий 9; 22 Жилет утеплений 8;
-- 24 Чоботи шкіряні 5; 25 Жилет джинсовий 7; 26 Парка зимова 3; 28 Плащ демісезонний 2

-- Завдання 6
CREATE VIEW orders_details AS
SELECT o.id, o.order_date, o.quantity, p.name AS product_name, c.full_name AS client_name
FROM orders o
JOIN products p ON p.id = o.product_id
LEFT JOIN clients c ON c.id = o.client_id;
SELECT * FROM orders_details ORDER BY id LIMIT 3;
-- 1 | 2026-09-01 | 2 | Футболка базова | Олена Ковальчук
-- 2 | 2026-09-02 | 1 | Джинси класичні | Максим Гриценко
-- 3 | 2026-09-03 | 1 | Куртка зимова | Олена Ковальчук
-- Виконати окремо
INSERT INTO orders_details (order_date, quantity, product_name, client_name)
VALUES (CURRENT_DATE, 1, 'Куртка зимова', 'Олена Ковальчук');
-- ERROR:  cannot insert into view "orders_details"
-- DETAIL:  Views that do not select from a single table or view are not automatically updatable.
-- HINT:  To enable inserting into the view, provide an INSTEAD OF INSERT trigger or an unconditional ON INSERT DO INSTEAD rule.
CREATE OR REPLACE VIEW products_low_stock AS
SELECT id, name, category, price, stock_quantity
FROM products
WHERE stock_quantity BETWEEN 1 AND 9
WITH CHECK OPTION;
-- Виконати окремо
INSERT INTO products_low_stock (name, category, price, stock_quantity)
VALUES ('Панама літня', 'Аксесуари', 350, 4);
-- Успішно: INSERT 0 1
-- Виконати окремо
INSERT INTO products_low_stock (name, category, price, stock_quantity)
VALUES ('Бейсболка', 'Аксесуари', 390, 50);
-- ERROR:  new row violates check option for view "products_low_stock"
-- DETAIL:  Failing row contains (30, Бейсболка, Аксесуари, null, 390, 50, 468, f).
SELECT * FROM products_low_stock ORDER BY id;
-- Результат: 9 рядків (додалась 29 | Панама літня | 4), Бейсболки немає
SELECT COUNT(*) FROM products WHERE name = 'Бейсболка';
-- Результат: 0
