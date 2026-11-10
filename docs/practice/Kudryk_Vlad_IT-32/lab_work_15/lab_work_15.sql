
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS complaints;
DROP TABLE IF EXISTS couriers;
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

CREATE TABLE couriers (
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    phone TEXT UNIQUE,
    transport TEXT
);

CREATE TABLE complaints (
    id INTEGER PRIMARY KEY,
    courier_id INTEGER NOT NULL,
    complaint_type TEXT NOT NULL
        CHECK (complaint_type IN ('Запізнення', 'Пошкоджене замовлення', 'Грубість')),
    complaint_date TEXT NOT NULL,
    description TEXT,
    status TEXT NOT NULL DEFAULT 'Нова',
    FOREIGN KEY (courier_id) REFERENCES couriers(id) ON DELETE RESTRICT
);

INSERT INTO restaurants (id, name, category) VALUES
    (1, 'Смак', 'Українська'),
    (2, 'Pizza House', 'Піца'),
    (3, 'Burger Point', 'Бургери'),
    (4, 'Sushi Master', 'Суші');

INSERT INTO clients (id, full_name, phone) VALUES
    (1, 'Олександр Петренко', '+380501112233'),
    (2, 'Ірина Коваль', '+380672223344'),
    (3, 'Андрій Шевченко', '+380671234567'),
    (4, 'Марія Бондаренко', '+380504445566');

INSERT INTO orders (id, restaurant_id, client_id, dish_name, price, order_date, status) VALUES
    (1, 1, 1,    'Борщ український', 120.00, '2026-09-01', 'Доставлено'),
    (2, 2, 2,    'Піца Маргарита',   220.00, '2026-09-01', 'Нове'),
    (3, 3, 3,    'Бургер класичний', 189.00, '2026-09-02', 'Нове'),
    (4, 1, 4,    'Вареники',         140.00, '2026-09-03', 'Нове'),
    (5, 2, 1,    'Піца Пепероні',    240.00, '2026-09-04', 'Доставлено'),
    (6, 2, NULL, 'Салат Цезар',      159.00, '2026-09-06', 'Нове'),
    (7, 3, 1,    'Бургер з беконом', 199.00, '2026-09-08', 'Нове'),
    (8, 1, 4,    'Вареники',         140.00, '2026-09-10', 'Нове');

INSERT INTO couriers (id, full_name, phone, transport) VALUES
    (1, 'Богдан Мельник', '+380501000001', 'Велосипед'),
    (2, 'Олена Кравець',  '+380502000002', 'Скутер'),
    (3, 'Тарас Лисенко',  '+380503000003', 'Авто'),
    (4, 'Ніна Гончар',    '+380504000004', 'Пішки'),
    (5, 'Сергій Руденко', '+380505000005', 'Скутер'),
    (6, 'Тарас Лисенко',  '+380506000006', 'Велосипед');

INSERT INTO complaints (id, courier_id, complaint_type, complaint_date, description, status) VALUES
    (1,  1, 'Запізнення',            '2026-07-05', 'Запізнився на 25 хвилин',        'Розглянуто'),
    (2,  1, 'Запізнення',            '2026-08-12', 'Запізнився на 40 хвилин',        'Нова'),
    (3,  1, 'Пошкоджене замовлення', '2026-09-02', 'Розлитий суп',                   'Розглянуто'),
    (4,  1, 'Запізнення',            '2026-09-10', 'Запізнився на 15 хвилин',        'Нова'),
    (5,  2, 'Запізнення',            '2026-08-20', 'Запізнилась на 30 хвилин',       'Нова'),
    (6,  2, 'Грубість',              '2026-09-03', 'Грубо розмовляла з клієнтом',    'Нова'),
    (7,  2, 'Запізнення',            '2026-09-15', 'Запізнилась на 20 хвилин',       'Нова'),
    (8,  3, 'Пошкоджене замовлення', '2026-06-18', 'Зім''ята коробка з піцою',       'Нова'),
    (9,  3, 'Запізнення',            '2026-09-21', 'Запізнився на 35 хвилин',        'Нова'),
    (10, 4, 'Грубість',              '2026-09-25', 'Не привітався, кинув пакет',     'Нова'),
    (11, 6, 'Пошкоджене замовлення', '2026-09-12', 'Перекинув пакет з їжею',         'Нова'),
    (12, 6, 'Грубість',              '2026-09-18', 'Відмовився піднятися до дверей', 'Нова');

EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE client_id = 1;
-- План: SCAN orders

CREATE INDEX idx_orders_client ON orders(client_id);

EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE client_id = 1;

EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE client_id = 1 AND status = 'Нове';

CREATE INDEX idx_orders_client_status ON orders(client_id, status);

EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE client_id = 1 AND status = 'Нове';

EXPLAIN QUERY PLAN
SELECT * FROM orders ORDER BY order_date;

CREATE INDEX idx_orders_date ON orders(order_date);

EXPLAIN QUERY PLAN
SELECT * FROM orders ORDER BY order_date;

DROP INDEX idx_orders_client;

EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE client_id = 1;

SELECT name FROM sqlite_master WHERE type = 'index' AND tbl_name = 'orders';
