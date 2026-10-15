PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT,
    category TEXT,
    size TEXT,
    price REAL,
    stock_quantity INTEGER
);

CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    last_name TEXT,
    first_name TEXT,
    email TEXT,
    city TEXT
);

CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    product_id INTEGER,
    customer_id INTEGER,
    order_date TEXT,
    quantity INTEGER,
    status TEXT
);

INSERT INTO products VALUES
(1, 'Футболка біла', 'Футболки', 'M', 450, 20),
(2, 'Футболка чорна', 'Футболки', 'L', 500, 15),
(3, 'Джинси сині', 'Джинси', 'M', 1200, 10),
(4, 'Кепка', 'Аксесуари', 'L', 300, 25);

INSERT INTO customers VALUES
(1, 'Тарасюк', 'Олександр', 'o.tarasiuk@example.com', 'Цумань'),
(2, 'Петренко', 'Максим', 'max@example.com', 'Луцьк'),
(3, 'Іваненко', 'Андрій', 'andriy@example.com', 'Рівне');

INSERT INTO orders VALUES
(1, 1, 1, '2026-09-20', 2, 'виконано'),
(2, 2, 2, '2026-09-21', 1, 'виконано'),
(3, 3, 3, '2026-09-22', 3, 'виконано'),
(4, 1, 2, '2026-09-23', 2, 'виконано'),
(5, 4, 1, '2026-09-24', 1, 'виконано'),
(6, 2, 3, '2026-09-25', 2, 'виконано'),
(7, 3, 1, '2026-09-26', 1, 'виконано'),
(8, 1, 3, '2026-09-27', 1, 'виконано'),
(9, 4, 2, '2026-09-28', 1, 'виконано'),
(10, 2, 1, '2026-09-29', 2, 'виконано');