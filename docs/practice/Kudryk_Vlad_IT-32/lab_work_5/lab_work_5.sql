
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
    full_name TEXT,
    phone TEXT
);

CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    restaurant_id INTEGER,
    client_id INTEGER,
    dish_name TEXT,
    price REAL,
    order_date TEXT,
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

INSERT INTO orders (restaurant_id, client_id, dish_name, price, order_date) VALUES
    (1, 1, 'Борщ український', 120.00, '2026-09-01'),
    (2, 2, 'Піца Маргарита', 220.00, '2026-09-01'),
    (3, 3, 'Бургер класичний', 189.00, '2026-09-02'),
    (1, 4, 'Вареники', 140.00, '2026-09-03'),
    (2, 1, 'Піца Пепероні', 240.00, '2026-09-04');

PRAGMA foreign_keys = OFF;

ALTER TABLE clients RENAME TO clients_old;

CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    phone TEXT
);

INSERT INTO clients SELECT * FROM clients_old;

DROP TABLE clients_old;

PRAGMA foreign_keys = ON;

INSERT INTO clients (id, phone) VALUES (5, '+380671110000');

PRAGMA foreign_keys = OFF;

ALTER TABLE clients RENAME TO clients_old;

CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    phone TEXT UNIQUE
);

INSERT INTO clients SELECT * FROM clients_old;

DROP TABLE clients_old;

PRAGMA foreign_keys = ON;

INSERT INTO clients (id, full_name, phone) VALUES (5, 'Тестовий Клієнт', '+380501112233');

ALTER TABLE orders RENAME TO orders_old;

CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    restaurant_id INTEGER,
    client_id INTEGER,
    dish_name TEXT,
    price REAL CHECK (price > 0),
    order_date TEXT,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE RESTRICT,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE SET NULL
);

INSERT INTO orders SELECT * FROM orders_old;

DROP TABLE orders_old;

INSERT INTO orders (restaurant_id, client_id, dish_name, price, order_date)
VALUES (1, 1, 'Тестова страва', -50.00, '2026-09-05');

INSERT INTO orders (restaurant_id, client_id, dish_name, price, order_date)
VALUES (2, 2, 'Салат Цезар', 159.00, '2026-09-06');


ALTER TABLE orders RENAME TO orders_old;

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

INSERT INTO orders (id, restaurant_id, client_id, dish_name, price, order_date)
SELECT id, restaurant_id, client_id, dish_name, price, order_date FROM orders_old;

DROP TABLE orders_old;

INSERT INTO orders (restaurant_id, client_id, dish_name, price, order_date)
VALUES (3, 3, 'Піца Гавайська', 210.00, '2026-09-07');

SELECT id, dish_name, status FROM orders WHERE dish_name = 'Піца Гавайська';

UPDATE orders SET price = -10.0 WHERE id = 1;
