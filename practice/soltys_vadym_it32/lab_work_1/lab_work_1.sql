CREATE TABLE products (
    id                 INTEGER PRIMARY KEY,
    name               TEXT NOT NULL,
    category           TEXT NOT NULL,
    size               TEXT,
    price              REAL NOT NULL,
    stock_quantity     INTEGER NOT NULL
);

INSERT INTO products (name, category, size, price, stock_quantity) VALUES
    ('Футболка базова', 'Футболки', 'M', 349.00, 25),
    ('Джинси slim fit', 'Штани', '32', 899.00, 12),
    ('Куртка зимова', 'Верхній одяг', 'L', 2499.00, 6),
    ('Сукня літня', 'Сукні', 'S', 749.00, 15),
    ('Кросівки повсякденні', 'Взуття', '42', 1599.00, 8),
    ('Светр вовняний', 'Светри', 'M', 999.00, 10);

.schema products
.tables

SELECT * FROM products;