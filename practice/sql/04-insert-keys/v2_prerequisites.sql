-- Variant 2. Clothing store
-- State of the database BEFORE Practice 4: only dimension table 1
-- ("products"), as Practice 1 should have produced.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS products;

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT,
    size TEXT,
    price REAL NOT NULL,
    stock_quantity INTEGER NOT NULL DEFAULT 0
);

INSERT INTO products (name, category, size, price, stock_quantity) VALUES
    ('Футболка базова', 'Футболки', 'M', 299.0, 40),
    ('Джинси класичні', 'Джинси', '32', 899.0, 15),
    ('Куртка зимова', 'Куртки', 'L', 2499.0, 8),
    ('Сукня літня', 'Сукні', 'S', 650.0, 20),
    ('Кросівки спортивні', 'Взуття', '42', 1899.0, 12),
    ('Шапка вовняна', 'Аксесуари', 'один розмір', 250.0, 30);
