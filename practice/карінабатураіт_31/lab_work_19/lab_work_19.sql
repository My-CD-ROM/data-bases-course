-- Практична робота 19.
-- Студентка: Батура Каріна Віталіївна, група ІТ-31


CREATE TABLE customers (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT
);

CREATE TABLE products (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    size TEXT,
    price REAL NOT NULL CHECK (price > 0),
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    UNIQUE (name, size)
);

CREATE TABLE orders (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    order_date TEXT NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    status TEXT NOT NULL DEFAULT 'new',
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE RESTRICT,
    FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
);

-- 2. Синхронізація лічильників автоінкременту (setval) після імпорту CSV
--    та перевірочні вставки без явного зазначення id (Завдання 4)

SELECT setval(pg_get_serial_sequence('customers', 'id'), COALESCE((SELECT MAX(id) FROM customers), 1));
SELECT setval(pg_get_serial_sequence('products', 'id'), COALESCE((SELECT MAX(id) FROM products), 1));
SELECT setval(pg_get_serial_sequence('orders', 'id'), COALESCE((SELECT MAX(id) FROM orders), 1));

INSERT INTO customers (first_name, last_name, email, phone)
VALUES ('Тест', 'Користувач', 'test_lab19@example.com', '+380500000000');

INSERT INTO products (name, category, size, price, stock_quantity)
VALUES ('Тестовий товар', 'Аксесуари', 'M', 299.0, 5);

INSERT INTO orders (product_id, customer_id, order_date, quantity, status)
VALUES (
    (SELECT MAX(id) FROM products),
    (SELECT MAX(id) FROM customers),
    '2026-11-24',
    1,
    'new'
);

-- 3. Підтвердження збігу кількості рядків COUNT(*) до й після перенесення

SELECT COUNT(*) AS customers_cnt FROM customers;
SELECT COUNT(*) AS products_cnt FROM products;
SELECT COUNT(*) AS orders_cnt FROM orders;

-- Результати перевірки COUNT(*):
-- Таблиця customers: у SQLite було 6 рядків -> після імпорту CSV та 1 тестового INSERT стало 7 рядків (6 + 1).
-- Таблиця products:  у SQLite було 16 рядків -> після імпорту CSV та 1 тестового INSERT стало 17 рядків (16 + 1).
-- Таблиця orders:    у SQLite було 11 рядків -> після імпорту CSV та 1 тестового INSERT стало 12 рядків (11 + 1).

-- 4. Перевірка роботи зовнішніх ключів без PRAGMA foreign_keys (Завдання 5)

INSERT INTO orders (product_id, customer_id, order_date, quantity, status)
VALUES (1, 999999, '2026-11-24', 1, 'new');

-- Точний текст помилки PostgreSQL у вкладці Messages:
-- ERROR:  insert або update в таблиці "orders" порушує обмеження зовнішнього ключа "orders_customer_id_fkey"
-- Ключ (customer_id)=(999999) не присутній в таблиці "customers".
-- ПОМИЛКА:  insert або update в таблиці "orders" порушує обмеження зовнішнього ключа "orders_customer_id_fkey"
-- SQL state: 23503
-- Detail: Ключ (customer_id)=(999999) не присутній в таблиці "customers".