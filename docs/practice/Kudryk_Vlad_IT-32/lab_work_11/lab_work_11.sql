
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
    (5, 2, 1,    'Піца Пепероні',    240.00, '2026-09-04', 'Нове'),
    (6, 2, NULL, 'Салат Цезар',      159.00, '2026-09-06', 'Нове');

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

INSERT INTO couriers (id, full_name, phone, transport) VALUES
    (1, 'Богдан Мельник', '+380501000001', 'Велосипед'),
    (2, 'Олена Кравець',  '+380502000002', 'Скутер'),
    (3, 'Тарас Лисенко',  '+380503000003', 'Авто'),
    (4, 'Ніна Гончар',    '+380504000004', 'Пішки'),
    (5, 'Сергій Руденко', '+380505000005', 'Скутер');

INSERT INTO complaints (courier_id, complaint_type, complaint_date, description) VALUES
    (1, 'Запізнення',            '2026-07-05', 'Запізнився на 25 хвилин'),
    (1, 'Запізнення',            '2026-08-12', 'Запізнився на 40 хвилин'),
    (1, 'Пошкоджене замовлення', '2026-09-02', 'Розлитий суп'),
    (1, 'Запізнення',            '2026-09-10', 'Запізнився на 15 хвилин'),
    (2, 'Запізнення',            '2026-08-20', 'Запізнилась на 30 хвилин'),
    (2, 'Грубість',              '2026-09-03', 'Грубо розмовляла з клієнтом'),
    (2, 'Запізнення',            '2026-09-15', 'Запізнилась на 20 хвилин'),
    (3, 'Пошкоджене замовлення', '2026-06-18', 'Зім''ята коробка з піцою'),
    (3, 'Запізнення',            '2026-09-21', 'Запізнився на 35 хвилин'),
    (4, 'Грубість',              '2026-09-25', 'Не привітався, кинув пакет');

UPDATE complaints SET status = 'Розглянуто' WHERE id IN (1, 3);

SELECT couriers.full_name AS кур_єр, COUNT(*) AS кількість_скарг
FROM couriers
JOIN complaints ON complaints.courier_id = couriers.id
GROUP BY couriers.id;

SELECT couriers.full_name AS кур_єр, COUNT(*) AS кількість_скарг
FROM couriers
JOIN complaints ON complaints.courier_id = couriers.id
GROUP BY couriers.id
HAVING COUNT(*) >= 3;

SELECT couriers.full_name AS кур_єр, COUNT(*) AS запізнень
FROM couriers
JOIN complaints ON complaints.courier_id = couriers.id
WHERE complaints.complaint_type = 'Запізнення'
GROUP BY couriers.id
HAVING COUNT(*) >= 3;

INSERT INTO couriers (id, full_name, phone, transport) VALUES
    (6, 'Тарас Лисенко', '+380506000006', 'Велосипед');

INSERT INTO complaints (courier_id, complaint_type, complaint_date, description) VALUES
    (6, 'Пошкоджене замовлення', '2026-09-12', 'Перекинув пакет з їжею'),
    (6, 'Грубість',              '2026-09-18', 'Відмовився піднятися до дверей');

SELECT couriers.full_name AS кур_єр, COUNT(*) AS кількість_скарг
FROM couriers
JOIN complaints ON complaints.courier_id = couriers.id
GROUP BY couriers.id
HAVING COUNT(*) >= 3;

SELECT couriers.full_name AS кур_єр, COUNT(*) AS кількість_скарг
FROM couriers
JOIN complaints ON complaints.courier_id = couriers.id
GROUP BY couriers.full_name
HAVING COUNT(*) >= 3;

SELECT couriers.full_name AS кур_єр, COUNT(*) AS запізнень
FROM couriers
LEFT JOIN complaints ON complaints.courier_id = couriers.id
WHERE complaints.complaint_type = 'Запізнення'
GROUP BY couriers.id
HAVING COUNT(*) >= 3;
