
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
    (3, 'Андрій Шевченко', '+380671234567'),
    (4, 'Марія Бондаренко', '+380504445566');

INSERT INTO orders (id, restaurant_id, client_id, dish_name, price, order_date, status) VALUES
    (1, 1, 1, 'Борщ український', 120.00, '2026-09-01', 'Доставлено'),
    (2, 2, 2, 'Піца Маргарита', 220.00, '2026-09-01', 'Нове'),
    (3, 3, 3, 'Бургер класичний', 189.00, '2026-09-02', 'Нове'),
    (4, 1, 4, 'Вареники', 140.00, '2026-09-03', 'Нове'),
    (5, 2, 1, 'Піца Пепероні', 240.00, '2026-09-04', 'Нове'),
    (6, 2, 2, 'Салат Цезар', 159.00, '2026-09-06', 'Нове');

SELECT
    restaurants.name  AS ресторан,
    orders.dish_name  AS страва,
    orders.price      AS ціна,
    orders.order_date AS дата,
    orders.status     AS статус
FROM orders
JOIN restaurants ON orders.restaurant_id = restaurants.id
ORDER BY orders.order_date;

SELECT
    restaurants.name  AS ресторан,
    clients.full_name AS клієнт,
    orders.dish_name  AS страва,
    orders.order_date AS дата
FROM orders
JOIN restaurants ON orders.restaurant_id = restaurants.id
JOIN clients     ON orders.client_id     = clients.id
ORDER BY orders.order_date;

INSERT INTO restaurants (id, name, category) VALUES (4, 'Sushi Master', 'Суші');

SELECT restaurants.name AS ресторан_без_замовлень
FROM restaurants
LEFT JOIN orders ON orders.restaurant_id = restaurants.id
WHERE orders.id IS NULL;

SELECT COUNT(*) AS cross_join_count FROM restaurants, clients;

SELECT COUNT(*) AS restaurants_count FROM restaurants;

SELECT COUNT(*) AS clients_count FROM clients;
