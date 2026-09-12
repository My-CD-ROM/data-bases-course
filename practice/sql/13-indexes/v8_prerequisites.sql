DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS couriers;
DROP TABLE IF EXISTS dishes;
CREATE TABLE dishes (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT,
    price REAL,
    restaurant TEXT
);
CREATE TABLE couriers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone TEXT,
    transport TEXT
);
CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    dish_id INTEGER REFERENCES dishes(id),
    courier_id INTEGER REFERENCES couriers(id),
    order_date TEXT NOT NULL,
    address TEXT,
    status TEXT
);
INSERT INTO dishes VALUES (1, 'Борщ український', 'супи', 95.0, 'Смачно і Точка');
INSERT INTO dishes VALUES (2, 'Піца Маргарита', 'піца', 220.0, 'Італьяно');
INSERT INTO dishes VALUES (3, 'Суші сет Філадельфія', 'суші', 350.0, 'Токіо Хаус');
INSERT INTO dishes VALUES (4, 'Вареники з картоплею', 'перші страви', 130.0, 'Смачно і Точка');
INSERT INTO dishes VALUES (5, 'Бургер класичний', 'фастфуд', 180.0, 'Burger Zone');
INSERT INTO dishes VALUES (6, 'Салат Цезар', 'салати', 160.0, 'Grill Bar');
INSERT INTO dishes VALUES (7, 'Плов з бараниною', 'гарячі страви', 190.0, 'Схід');
INSERT INTO dishes VALUES (8, 'Паста Карбонара', 'паста', 210.0, 'Італьяно');
INSERT INTO dishes VALUES (9, 'Рол Каліфорнія', 'суші', 280.0, 'Токіо Хаус');
INSERT INTO dishes VALUES (10, 'Курка гриль', 'гарячі страви', 175.0, 'Grill Bar');
INSERT INTO dishes VALUES (11, 'Хачапурі', 'випічка', 140.0, 'Схід');
INSERT INTO dishes VALUES (12, 'Тірамісу', 'десерти', 120.0, 'Італьяно');
INSERT INTO couriers VALUES (1, 'Кравець', 'Максим', '+380966000001', 'пішки');
INSERT INTO couriers VALUES (2, 'Гончаренко', 'Оксана', '+380966000002', 'скутер');
INSERT INTO couriers VALUES (3, 'Олійник', 'Оксана', '+380966000003', 'велосипед');
INSERT INTO couriers VALUES (4, 'Бондаренко', 'Тарас', '+380966000004', 'скутер');
INSERT INTO couriers VALUES (5, 'Савченко', 'Ігор', '+380966000005', 'велосипед');
INSERT INTO couriers VALUES (6, 'Іванов', 'Роман', '+380966000006', 'скутер');
INSERT INTO couriers VALUES (7, 'Шевченко', 'Тарас', '+380966000007', 'автомобіль');
INSERT INTO couriers VALUES (8, 'Коваль', 'Петро', '+380966000008', 'пішки');
INSERT INTO couriers VALUES (9, 'Іванов', 'Андрій', '+380966000009', 'автомобіль');
INSERT INTO couriers VALUES (10, 'Поліщук', 'Роман', '+380966000010', 'пішки');
INSERT INTO couriers VALUES (11, 'Ткаченко', 'Петро', '+380966000011', 'автомобіль');
INSERT INTO couriers VALUES (12, 'Шевченко', 'Софія', '+380966000012', 'автомобіль');
INSERT INTO orders VALUES (1, 2, 7, '2024-04-14', 'вул. Лесі Українки, 135', 'прийнято');
INSERT INTO orders VALUES (2, 7, 5, '2025-04-11', 'вул. Франка, 20', 'скасовано');
INSERT INTO orders VALUES (3, 11, 2, '2024-06-12', 'вул. Франка, 61', 'прийнято');
INSERT INTO orders VALUES (4, 3, 5, '2024-03-20', 'вул. Франка, 20', 'готується');
INSERT INTO orders VALUES (5, 11, 8, '2025-10-25', 'вул. Лесі Українки, 145', 'скасовано');
INSERT INTO orders VALUES (6, 6, 11, '2025-03-15', 'вул. Шевченка, 121', 'доставлено');
INSERT INTO orders VALUES (7, 11, 5, '2025-10-02', 'вул. Грушевського, 130', 'прийнято');
INSERT INTO orders VALUES (8, 5, 8, '2025-01-02', 'вул. Грушевського, 74', 'прийнято');
INSERT INTO orders VALUES (9, 11, 2, '2025-08-19', 'вул. Шевченка, 116', 'скасовано');
INSERT INTO orders VALUES (10, 11, 4, '2025-10-16', 'вул. Франка, 16', 'доставлено');
INSERT INTO orders VALUES (11, 2, 6, '2024-09-21', 'вул. Франка, 11', 'готується');
INSERT INTO orders VALUES (12, 12, 8, '2025-09-17', 'вул. Франка, 94', 'в дорозі');
INSERT INTO orders VALUES (13, 5, 7, '2025-06-22', 'вул. Шевченка, 86', 'прийнято');
INSERT INTO orders VALUES (14, 6, 2, '2025-05-09', 'вул. Франка, 86', 'прийнято');
INSERT INTO orders VALUES (15, 10, 11, '2024-06-10', 'вул. Лесі Українки, 34', 'скасовано');
INSERT INTO orders VALUES (16, 12, 2, '2025-09-13', 'вул. Грушевського, 33', 'скасовано');
INSERT INTO orders VALUES (17, 2, 11, '2025-09-12', 'вул. Шевченка, 93', 'в дорозі');
INSERT INTO orders VALUES (18, 3, 4, '2025-08-07', 'вул. Франка, 36', 'готується');
INSERT INTO orders VALUES (19, 2, 5, '2024-09-25', 'вул. Шевченка, 87', 'скасовано');
INSERT INTO orders VALUES (20, 3, 10, '2025-03-06', 'вул. Франка, 43', 'доставлено');
