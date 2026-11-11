-- Практична робота №1 
-- Варіант №2: Інтернет-магазин одягу
-- Таблиця вимір: products 
CREATE TABLE IF NOT EXISTS products (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    name            TEXT NOT NULL,
    category        TEXT NOT NULL,
    size            TEXT NOT NULL,
    price           REAL NOT NULL,
    stock_quantity  INTEGER NOT NULL
);

INSERT INTO products (name, category, size, price, stock_quantity) VALUES
    ('Худі оверсайз КІКІ', 'Верхній одяг', 'M', 1850.00, 15),
    ('Джинси wide-leg', 'Штани', 'S', 2100.00, 8),
    ('Футболка базова бавовняна', 'Топ', 'L', 650.00, 30),
    ('Сукня міді лляна', 'Сукні', 'XS', 2400.00, 5),
    ('Куртка демісезонна', 'Верхній одяг', 'M', 3200.00, 10),
    ('Светр крупної в`язки', 'Трикотаж', 'S', 1950.00, 12);

SELECT * FROM products;
