
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
    (3, 'Burger Point', 'Бургери'),
    (4, 'Sushi Master', 'Суші');

INSERT INTO clients (id, full_name, phone) VALUES
    (1, 'Олександр Петренко', '+380501112233'),
    (2, 'Ірина Коваль', '+380672223344'),
    (3, 'Андрій Шевченко', '+380671234567'),
    (4, 'Марія Бондаренко', '+380504445566');

INSERT INTO orders (id, restaurant_id, client_id, dish_name, price, order_date, status) VALUES
    (1, 1, 1, 'Борщ український', 120.00, '2026-09-01', 'Доставлено'),
    (2, 2, 2, 'Піца Маргарита', 220.00, '2026-09-01', 'Нове'),
    (3, 3, 3, 'Бургер класичний', 189.00, '2026-09-02', 'Нове'),
    (4, 1, 4, 'Вареники', 140.00, '2026-09-03', 'Нове'),
    (5, 2, 1, 'Піца Пепероні', 240.00, '2026-09-04', 'Нове'),
    (6, 2, 2, 'Салат Цезар', 159.00, '2026-09-06', 'Нове');


SELECT COUNT(*) AS всього_замовлень, COUNT(client_id) AS замовлень_з_клієнтом
FROM orders;

UPDATE orders SET client_id = NULL WHERE id = 6;

SELECT COUNT(*) AS всього_замовлень, COUNT(client_id) AS замовлень_з_клієнтом
FROM orders;

SELECT SUM(price) AS сумарна_виручка, AVG(price) AS середній_чек
FROM orders;

SELECT MIN(order_date) AS найперше_замовлення, MAX(order_date) AS останнє_замовлення
FROM orders;

SELECT
    COUNT(*)      AS кількість_замовлень,
    SUM(price)    AS сумарна_виручка,
    AVG(price)    AS середній_чек,
    MIN(price)    AS мінімальна_ціна,
    MAX(price)    AS максимальна_ціна
FROM orders;

SELECT AVG(orders.price) AS середній_чек_піца
FROM orders
JOIN restaurants ON orders.restaurant_id = restaurants.id
WHERE restaurants.category = 'Піца';

SELECT SUM(price) AS сума_неіснуючого_ресторану
FROM orders
WHERE restaurant_id = 9999;
