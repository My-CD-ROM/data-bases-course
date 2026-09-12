DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT,
    size TEXT,
    price REAL,
    stock_quantity INTEGER
);
CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT UNIQUE,
    city TEXT
);
CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    customer_id INTEGER REFERENCES customers(id),
    order_date TEXT NOT NULL,
    quantity INTEGER,
    status TEXT
);
INSERT INTO products VALUES (1, 'Футболка базова', 'футболки', 'M', 349.0, 40);
INSERT INTO products VALUES (2, 'Джинси класичні', 'джинси', 'L', 899.0, 25);
INSERT INTO products VALUES (3, 'Сукня літня', 'сукні', 'S', 749.0, 15);
INSERT INTO products VALUES (4, 'Куртка джинсова', 'куртки', 'M', 1299.0, 10);
INSERT INTO products VALUES (5, 'Худі оверсайз', 'худі', 'XL', 999.0, 20);
INSERT INTO products VALUES (6, 'Спортивні штани', 'штани', 'L', 649.0, 18);
INSERT INTO products VALUES (7, 'Сорочка офісна', 'сорочки', 'M', 599.0, 22);
INSERT INTO products VALUES (8, 'Спідниця міні', 'спідниці', 'S', 549.0, 12);
INSERT INTO products VALUES (9, 'Плащ весняний', 'плащі', 'L', 1499.0, 8);
INSERT INTO products VALUES (10, 'Шорти джинсові', 'шорти', 'M', 449.0, 30);
INSERT INTO products VALUES (11, 'Светр в''язаний', 'светри', 'M', 899.0, 14);
INSERT INTO products VALUES (12, 'Пальто зимове', 'пальта', 'L', 2199.0, 6);
INSERT INTO customers VALUES (1, 'Гриценко', 'Софія', 'софія.гриценко1@example.com', 'Харків');
INSERT INTO customers VALUES (2, 'Савченко', 'Роман', 'роман.савченко2@example.com', 'Харків');
INSERT INTO customers VALUES (3, 'Коваль', 'Роман', 'роман.коваль3@example.com', 'Вінниця');
INSERT INTO customers VALUES (4, 'Олійник', 'Петро', 'петро.олійник4@example.com', 'Львів');
INSERT INTO customers VALUES (5, 'Іванов', 'Ігор', 'ігор.іванов5@example.com', 'Львів');
INSERT INTO customers VALUES (6, 'Бондаренко', 'Богдан', 'богдан.бондаренко6@example.com', 'Одеса');
INSERT INTO customers VALUES (7, 'Олійник', 'Богдан', 'богдан.олійник7@example.com', 'Харків');
INSERT INTO customers VALUES (8, 'Литвин', 'Софія', 'софія.литвин8@example.com', 'Львів');
INSERT INTO customers VALUES (9, 'Іванов', 'Оксана', 'оксана.іванов9@example.com', 'Львів');
INSERT INTO customers VALUES (10, 'Гриценко', 'Ірина', 'ірина.гриценко10@example.com', 'Одеса');
INSERT INTO customers VALUES (11, 'Олійник', 'Тарас', 'тарас.олійник11@example.com', 'Полтава');
INSERT INTO customers VALUES (12, 'Гриценко', 'Роман', 'роман.гриценко12@example.com', 'Київ');
INSERT INTO orders VALUES (1, 7, 5, '2025-05-14', 3, 'скасовано');
INSERT INTO orders VALUES (2, 3, 4, '2025-04-02', 3, 'оформлено');
INSERT INTO orders VALUES (3, 12, 6, '2024-01-19', 2, 'відправлено');
INSERT INTO orders VALUES (4, 1, 9, '2024-03-03', 3, 'оформлено');
INSERT INTO orders VALUES (5, 11, 4, '2025-02-19', 1, 'оформлено');
INSERT INTO orders VALUES (6, 10, 2, '2025-11-19', 3, 'доставлено');
INSERT INTO orders VALUES (7, 5, 4, '2025-04-09', 2, 'відправлено');
INSERT INTO orders VALUES (8, 11, 11, '2025-08-11', 1, 'оформлено');
INSERT INTO orders VALUES (9, 8, 10, '2024-02-18', 1, 'доставлено');
INSERT INTO orders VALUES (10, 3, 6, '2024-04-12', 2, 'відправлено');
INSERT INTO orders VALUES (11, 8, 9, '2025-10-26', 3, 'оформлено');
INSERT INTO orders VALUES (12, 11, 9, '2025-11-04', 1, 'доставлено');
INSERT INTO orders VALUES (13, 2, 2, '2024-05-10', 3, 'відправлено');
INSERT INTO orders VALUES (14, 12, 6, '2024-11-21', 2, 'скасовано');
INSERT INTO orders VALUES (15, 5, 1, '2024-11-14', 2, 'оформлено');
INSERT INTO orders VALUES (16, 1, 6, '2024-11-09', 1, 'скасовано');
INSERT INTO orders VALUES (17, 9, 12, '2025-09-01', 1, 'оформлено');
INSERT INTO orders VALUES (18, 12, 3, '2024-06-19', 3, 'відправлено');
INSERT INTO orders VALUES (19, 7, 3, '2024-05-12', 1, 'доставлено');
INSERT INTO orders VALUES (20, 4, 11, '2024-11-04', 2, 'скасовано');
