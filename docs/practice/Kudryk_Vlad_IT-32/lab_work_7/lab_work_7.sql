-- Практика 7. Запити з різними видами об'єднання таблиць у SQLite
-- Варіант 8. Служба доставки їжі
-- Структура таблиць НЕ змінюється — продовжуємо на базі Практики 6.

PRAGMA foreign_keys = ON;

-- =====================================================================
-- 0. Відтворення поточного стану (після Практик 4-6): 3 ресторани,
--    4 клієнти, 6 замовлень з усіма обмеженнями цілісності.
-- =====================================================================
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


-- =====================================================================
-- ЗАВДАННЯ 1. INNER JOIN: фактова таблиця + таблиця-вимір 1 (restaurants)
-- Замість restaurant_id показуємо назву ресторану.
-- =====================================================================
SELECT
    restaurants.name  AS ресторан,
    orders.dish_name  AS страва,
    orders.price      AS ціна,
    orders.order_date AS дата,
    orders.status     AS статус
FROM orders
JOIN restaurants ON orders.restaurant_id = restaurants.id
ORDER BY orders.order_date;

-- Результат:
-- ресторан      | страва             | ціна  | дата       | статус
-- Смак          | Борщ український   | 120.0 | 2026-09-01 | Доставлено
-- Pizza House   | Піца Маргарита     | 220.0 | 2026-09-01 | Нове
-- Burger Point  | Бургер класичний   | 189.0 | 2026-09-02 | Нове
-- Смак          | Вареники           | 140.0 | 2026-09-03 | Нове
-- Pizza House   | Піца Пепероні      | 240.0 | 2026-09-04 | Нове
-- Pizza House   | Салат Цезар        | 159.0 | 2026-09-06 | Нове


-- =====================================================================
-- ЗАВДАННЯ 2. INNER JOIN усіх трьох таблиць
-- Додано ще один JOIN — з clients — щоб бачити й ім'я клієнта.
-- =====================================================================
SELECT
    restaurants.name  AS ресторан,
    clients.full_name AS клієнт,
    orders.dish_name  AS страва,
    orders.order_date AS дата
FROM orders
JOIN restaurants ON orders.restaurant_id = restaurants.id
JOIN clients     ON orders.client_id     = clients.id
ORDER BY orders.order_date;

-- Результат:
-- ресторан      | клієнт              | страва             | дата
-- Смак          | Олександр Петренко  | Борщ український   | 2026-09-01
-- Pizza House   | Ірина Коваль        | Піца Маргарита     | 2026-09-01
-- Burger Point  | Андрій Шевченко     | Бургер класичний   | 2026-09-02
-- Смак          | Марія Бондаренко    | Вареники           | 2026-09-03
-- Pizza House   | Олександр Петренко  | Піца Пепероні      | 2026-09-04
-- Pizza House   | Ірина Коваль        | Салат Цезар        | 2026-09-06


-- =====================================================================
-- ЗАВДАННЯ 3. LEFT JOIN — рядок таблиці-виміру без жодної пари
-- На поточних даних усі 3 ресторани вже мають хоча б одне замовлення,
-- тому додано новий ресторан, якого ще ніхто не замовляв.
-- =====================================================================
INSERT INTO restaurants (id, name, category) VALUES (4, 'Sushi Master', 'Суші');

SELECT restaurants.name AS ресторан_без_замовлень
FROM restaurants
LEFT JOIN orders ON orders.restaurant_id = restaurants.id
WHERE orders.id IS NULL;

-- Результат: ('Sushi Master',) — єдиний ресторан без жодного замовлення.


-- =====================================================================
-- ЗАВДАННЯ 4. Свідома пастка CROSS JOIN (кома-синтаксис без WHERE)
-- =====================================================================
SELECT COUNT(*) AS cross_join_count FROM restaurants, clients;
-- Результат: 16

SELECT COUNT(*) AS restaurants_count FROM restaurants;
-- Результат: 4

SELECT COUNT(*) AS clients_count FROM clients;
-- Результат: 4
