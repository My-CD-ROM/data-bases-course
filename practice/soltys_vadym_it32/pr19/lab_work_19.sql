-- Практика 19. Створення бази даних у PostgreSQL (pgAdmin)
-- Варіант 2, інтернет-магазин одягу. Джерело даних: pr18/lab_work_18.db
-- Виконувати у Query Tool ЧАСТИНАМИ (виділити частину й натиснути F5).

-- Завдання 1. Створення бази даних (виконати окремо, на базі postgres),
-- після чого відкрити Query Tool саме на базі clothing_store_db.
CREATE DATABASE clothing_store_db;

-- Завдання 2. Переклад трьох CREATE TABLE

-- Таблиця-вимір 1
CREATE TABLE products (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    size TEXT,
    price REAL NOT NULL CHECK (price > 0),
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    price_with_vat REAL GENERATED ALWAYS AS (round((price * 1.2)::numeric, 2)) STORED,
    low_stock BOOLEAN GENERATED ALWAYS AS (stock_quantity < 10) STORED
);

-- Таблиця-вимір 2
CREATE TABLE clients (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE,
    phone TEXT,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Фактова таблиця
CREATE TABLE orders (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id INTEGER NOT NULL,
    client_id INTEGER,
    order_date DATE NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE RESTRICT,
    FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE SET NULL
);

-- Завдання 3. Перенесення даних через Import/Export Data (без SQL).
-- Порядок: products.csv -> clients.csv -> orders.csv
-- Режим Import, Format: csv, Encoding: UTF8, вкладка Options: Header увімкнено, Delimiter ",".
-- Для products на вкладці Columns прибрати price_with_vat і low_stock
-- (PostgreSQL обчислює їх сам, у CSV їх немає).

-- Завдання 4. Виправлення лічильників id
SELECT setval(pg_get_serial_sequence('products', 'id'), (SELECT MAX(id) FROM products));  -- 24
SELECT setval(pg_get_serial_sequence('clients', 'id'), (SELECT MAX(id) FROM clients));    -- 6
SELECT setval(pg_get_serial_sequence('orders', 'id'), (SELECT MAX(id) FROM orders));      -- 10

-- Перевірочні INSERT без явного id
INSERT INTO products (name, category, size, price, stock_quantity)
VALUES ('Жилет джинсовий', 'Куртки', 'M', 960, 7)
RETURNING id, name, price_with_vat, low_stock;      -- id = 25 | 1152 | true

INSERT INTO clients (full_name, email, phone)
VALUES ('Ірина Мельник', 'iryna.m@mail.com', '0679876543')
RETURNING id, full_name, registration_date;         -- id = 7

INSERT INTO orders (product_id, client_id, order_date, quantity)
VALUES (25, 7, CURRENT_DATE, 1)
RETURNING id, product_id, client_id;                -- id = 11 | 25 | 7

-- Завдання 5. Перевірка цілісності перенесення
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM clients;
SELECT COUNT(*) FROM orders;

-- Підтвердження збігу COUNT(*):
-- таблиця  | SQLite (до перенесення) | PostgreSQL після імпорту й тестового INSERT | без тестового рядка
-- products |           24            |                     25                      |         24  збігається
-- clients  |            5            |                      6                      |          5  збігається
-- orders   |           10            |                     11                      |         10  збігається

-- Свідома помилка: товару з id = 999 не існує. Виконати окремо.
INSERT INTO orders (product_id, client_id, order_date, quantity)
VALUES (999, 1, CURRENT_DATE, 1);

-- Точний текст помилки PostgreSQL:
-- ERROR:  insert or update on table "orders" violates foreign key constraint "orders_product_id_fkey"
-- DETAIL:  Key (product_id)=(999) is not present in table "products".
