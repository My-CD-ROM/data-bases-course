
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS dishes_staging;
DROP TABLE IF EXISTS dishes;
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

CREATE TABLE dishes (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT,
    price REAL NOT NULL,
    restaurant TEXT
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

CREATE INDEX idx_orders_client_status ON orders(client_id, status);
CREATE INDEX idx_orders_date ON orders(order_date);

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

INSERT INTO dishes (name, category, price, restaurant) VALUES
    ('Піца Маргарита', 'Піца', 259, 'Bon Pizza'),
    ('Борщ', 'Перші страви', 120, 'Смачно Вдома'),
    ('Суші сет Філадельфія', 'Суші', 449, 'Sushi Master'),
    ('Бургер класичний', 'Бургери', 189, 'BurgerHouse'),
    ('Салат Цезар', 'Салати', 159, 'Смачно Вдома'),
    ('Паста Карбонара', 'Паста', 229, 'Bon Pizza'),
    ('Том Ям', 'супи', 210, 'Токіо Хаус'),
    ('Дональдс бургер', 'фастфуд', 165, 'Burger Zone'),
    ('Лазанья', 'паста', 230, 'Італьяно'),
    ('Шаурма класична', 'фастфуд', 120, 'Схід'),
    ('Грецький салат', 'салати', 145, 'Grill Bar'),
    ('Піца Пепероні', 'піца', 250, 'Італьяно'),
    ('Онігірі сет', 'суші', 190, 'Токіо Хаус'),
    ('Чізкейк', 'десерти', 130, 'Італьяно');

.headers on
.mode column

CREATE TABLE dishes_staging (
    name TEXT,
    category TEXT,
    price REAL,
    restaurant TEXT
);

.mode csv
.import 
.mode column

SELECT COUNT(*) AS записів_у_staging FROM dishes_staging;

SELECT * FROM dishes_staging LIMIT 1;

DELETE FROM dishes_staging;

.mode csv
.separator ";"
.import 
.mode column

SELECT COUNT(*) AS записів_у_staging FROM dishes_staging;

.schema dishes

SELECT SUM(name = '')       AS name_empty,
       SUM(category = '')   AS category_empty,
       SUM(price = '')      AS price_empty,
       SUM(restaurant = '') AS restaurant_empty
FROM dishes_staging;

SELECT typeof(price) AS тип, COUNT(*) AS кількість
FROM dishes_staging
GROUP BY typeof(price);

SELECT name, category, price, restaurant, COUNT(*) AS cnt
FROM dishes_staging
GROUP BY name, category, price, restaurant
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS до_перенесення
FROM (SELECT DISTINCT name, category, price, restaurant
      FROM dishes_staging
      WHERE price <> '' AND name <> '');

SELECT COUNT(*) AS рядків_до, MAX(id) AS max_id_до FROM dishes;

INSERT INTO dishes (name, category, price, restaurant)
SELECT DISTINCT name, NULLIF(category, ''), NULLIF(price, ''), restaurant
FROM dishes_staging;

SELECT COUNT(*) AS рядків_після_невдалої_спроби FROM dishes;

INSERT INTO dishes (name, category, price, restaurant)
SELECT DISTINCT name, NULLIF(category, ''), price, restaurant
FROM dishes_staging
WHERE price <> '' AND name <> '';

SELECT COUNT(*) AS рядків_після, MAX(id) AS max_id_після FROM dishes;

SELECT id, name, category FROM dishes WHERE id > 14 AND category IS NULL;

SELECT s.name
FROM dishes_staging s
WHERE EXISTS (SELECT 1 FROM dishes d WHERE d.name = s.name AND d.restaurant = s.restaurant);

DROP TABLE dishes_staging;

.headers on
.mode csv
.output dishes_export.csv
SELECT id, name, category, price, restaurant FROM dishes WHERE id > 14;
.output stdout
