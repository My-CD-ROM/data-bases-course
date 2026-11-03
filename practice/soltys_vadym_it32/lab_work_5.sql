PRAGMA foreign_keys = OFF;
-- legacy_alter_table вимикає автоматичне "підправлення" FOREIGN KEY
-- в інших таблицях (orders) під час RENAME TABLE products/clients
PRAGMA legacy_alter_table = ON;

-- ============================================================
-- Завдання 1. NOT NULL на products.category
-- (колонка раніше не мала жодного обмеження, крім PRIMARY KEY на id)
-- ============================================================
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

-- ============================================================
-- Завдання 3. CHECK на products.price (діапазон допустимих значень)
-- ============================================================
ALTER TABLE products RENAME TO products_old;

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    size TEXT,
    price REAL NOT NULL CHECK (price > 0),
    stock_quantity INTEGER NOT NULL DEFAULT 0
);

INSERT INTO products SELECT * FROM products_old;
DROP TABLE products_old;

-- ============================================================
-- Завдання 2. UNIQUE на clients.email (email не повинен повторюватись)
-- ============================================================
ALTER TABLE clients RENAME TO clients_old;

CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE,
    phone TEXT,
    registration_date TEXT
);

INSERT INTO clients SELECT * FROM clients_old;
DROP TABLE clients_old;

-- ============================================================
-- Завдання 4. DEFAULT на clients.registration_date (+ NOT NULL)
-- ============================================================
ALTER TABLE clients RENAME TO clients_old;

CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE,
    phone TEXT,
    registration_date TEXT NOT NULL DEFAULT (date('now'))
);

INSERT INTO clients SELECT * FROM clients_old;
DROP TABLE clients_old;

PRAGMA legacy_alter_table = OFF;
PRAGMA foreign_keys = ON;

-- ============================================================
-- Завдання 5. Порушення обмеження через UPDATE (не INSERT)
-- Порушуємо CHECK (price > 0) з Завдання 3 оновленням наявного рядка
-- ============================================================
UPDATE products SET price = -100 WHERE id = 1;
