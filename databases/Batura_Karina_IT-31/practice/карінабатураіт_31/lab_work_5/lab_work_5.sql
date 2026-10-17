-- Практична робота №5
-- Студентка: Батура Каріна Віталіївна
-- Група: ІТ-31
-- Варіант: Магазин одягу (products, customers, orders)
PRAGMA foreign_keys = OFF;

ALTER TABLE products RENAME TO products_old;

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    size TEXT,
    price REAL NOT NULL,
    stock_quantity INTEGER NOT NULL DEFAULT 0
);

INSERT INTO products SELECT * FROM products_old;
DROP TABLE products_old;

PRAGMA foreign_keys = ON;

PRAGMA foreign_keys = OFF;

ALTER TABLE products RENAME TO products_old;

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    size TEXT,
    price REAL NOT NULL,
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    UNIQUE (name, size)
);

INSERT INTO products SELECT * FROM products_old;
DROP TABLE products_old;

PRAGMA foreign_keys = ON;

PRAGMA foreign_keys = OFF;

ALTER TABLE products RENAME TO products_old;

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    size TEXT,
    price REAL NOT NULL CHECK (price > 0),
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    UNIQUE (name, size)
);

INSERT INTO products SELECT * FROM products_old;
DROP TABLE products_old;

PRAGMA foreign_keys = ON;

INSERT INTO products (name, category, size, price, stock_quantity) 
VALUES ('Сорочка', 'Одяг', 'S', 500.0, 5);
PRAGMA foreign_keys = OFF;

ALTER TABLE orders RENAME TO orders_old;

CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    order_date TEXT NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    status TEXT NOT NULL DEFAULT 'new',
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE RESTRICT,
    FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
);

INSERT INTO orders (id, product_id, customer_id, order_date, quantity) 
SELECT id, product_id, customer_id, order_date, quantity FROM orders_old;

DROP TABLE orders_old;

PRAGMA foreign_keys = ON;

INSERT INTO orders (product_id, customer_id, order_date, quantity) 
VALUES (1, 1, '2026-09-28', 1);

SELECT * FROM orders WHERE id = (SELECT MAX(id) FROM orders);
UPDATE products SET price = -100 WHERE id = 1;
