
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS restaurants;

CREATE TABLE restaurants (
    id INTEGER PRIMARY KEY,
    name TEXT,
    category TEXT
);

CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    phone TEXT UNIQUE
);

CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    restaurant_id INTEGER,
    client_id INTEGER,
    dish_name TEXT,
    price REAL CHECK (price > 0),
    order_date TEXT,
    status TEXT NOT NULL DEFAULT 'Нове',
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE RESTRICT,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE SET NULL
);

INSERT INTO restaurants (id, name, category) VALUES
    (1, 'Смак', 'Українська'),
    (2, 'Pizza House', 'Піца'),
    (3, 'Burger Point', 'Бургери');

INSERT INTO clients (id, full_name, phone) VALUES
    (1, 'Олександр Петренко', '+380501112233'),
    (2, 'Ірина Коваль', '+380672223344'),
    (3, 'Андрій Шевченко', '+380933334455'),
    (4, 'Марія Бондаренко', '+380504445566');

INSERT INTO orders (id, restaurant_id, client_id, dish_name, price, order_date, status) VALUES
    (1, 1, 1, 'Борщ український', 120.00, '2026-09-01', 'Нове'),
    (2, 2, 2, 'Піца Маргарита', 220.00, '2026-09-01', 'Нове'),
    (3, 3, 3, 'Бургер класичний', 189.00, '2026-09-02', 'Нове'),
    (4, 1, 4, 'Вареники', 140.00, '2026-09-03', 'Нове'),
    (5, 2, 1, 'Піца Пепероні', 240.00, '2026-09-04', 'Нове'),
    (6, 2, 2, 'Салат Цезар', 159.00, '2026-09-06', 'Нове'),
    (7, 3, 3, 'Піца Гавайська', 210.00, '2026-09-07', 'Нове');

UPDATE orders SET status = 'Доставлено' WHERE id = 1;

SELECT id, dish_name, status FROM orders WHERE id = 1;

UPDATE clients SET phone = '+380671234567' WHERE id = 3;

SELECT id, full_name, phone FROM clients WHERE id = 3;

SELECT COUNT(*) AS count_before FROM orders;

DELETE FROM orders WHERE id = 7;

SELECT COUNT(*) AS count_after FROM orders;

UPDATE clients SET phone = '+380672223344' WHERE id = 1;

SELECT id, full_name, phone FROM clients WHERE id = 1;
