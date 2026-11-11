CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT,
    category TEXT,
    size TEXT,
    price REAL,
    stock_quantity INTEGER
);

INSERT INTO products
(id, name, category, size, price, stock_quantity)
VALUES
(1, 'Футболка Basic', 'Футболки', 'M', 350, 10),
(2, 'Футболка Oversize', 'Футболки', 'L', 450, 7),
(3, 'Джинси Classic', 'Штани', 'M', 900, 5),
(4, 'Худі Sport', 'Толстовки', 'L', 750, 8),
(5, 'Сорочка Casual', 'Сорочки', 'S', 600, 4),
(6, 'Куртка Light', 'Куртки', 'M', 1200, 3);