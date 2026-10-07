-- Практика 9. Формування запитів з групуванням даних
-- Варіант 8. Служба доставки їжі
-- Структура таблиць НЕ змінюється — продовжуємо на базі Практики 8.

PRAGMA foreign_keys = ON;

-- =====================================================================
-- 0. Відтворення поточного стану (після Практик 4-8): 4 ресторани,
--    4 клієнти, 6 замовлень (одне з client_id = NULL, Практика 8).
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


-- =====================================================================
-- ЗАВДАННЯ 1. GROUP BY по одній колонці таблиці-виміру (restaurant_id)
-- =====================================================================
SELECT restaurant_id, COUNT(*) AS кількість_замовлень
FROM orders
GROUP BY restaurant_id;
-- Результат:
-- restaurant_id | кількість_замовлень
-- 1             | 2
-- 2             | 3
-- 3             | 1


-- =====================================================================
-- ЗАВДАННЯ 2. Зрозуміла версія через JOIN + GROUP BY
-- LEFT JOIN, а не INNER JOIN: ресторан "Sushi Master" без жодного
-- замовлення теж повинен з'явитися в результаті з кількістю 0.
-- Групуємо за restaurants.id (первинний ключ), не за назвою.
-- =====================================================================
SELECT restaurants.name AS ресторан, COUNT(orders.id) AS кількість_замовлень
FROM restaurants
LEFT JOIN orders ON orders.restaurant_id = restaurants.id
GROUP BY restaurants.id;
-- Результат:
-- ресторан      | кількість_замовлень
-- Смак          | 2
-- Pizza House   | 3
-- Burger Point  | 1
-- Sushi Master  | 0


-- =====================================================================
-- ЗАВДАННЯ 3. Друга агрегатна функція в тій самій групі (AVG price)
-- =====================================================================
SELECT restaurants.name AS ресторан,
       COUNT(orders.id) AS кількість_замовлень,
       AVG(orders.price) AS середній_чек
FROM restaurants
LEFT JOIN orders ON orders.restaurant_id = restaurants.id
GROUP BY restaurants.id;
-- Результат:
-- ресторан      | кількість_замовлень | середній_чек
-- Смак          | 2                   | 130.0
-- Pizza House   | 3                   | 206.333...
-- Burger Point  | 1                   | 189.0
-- Sushi Master  | 0                   | NULL


-- =====================================================================
-- ЗАВДАННЯ 4. GROUP BY за двома колонками (статус + місяць замовлення)
-- =====================================================================
SELECT status, strftime('%Y-%m', order_date) AS місяць, COUNT(*) AS кількість
FROM orders
GROUP BY status, місяць;
-- Результат:
-- status       | місяць  | кількість
-- Доставлено   | 2026-09 | 1
-- Нове         | 2026-09 | 5


-- =====================================================================
-- ЗАВДАННЯ 5. Пастка "колонка поза GROUP BY"
-- dish_name не входить у GROUP BY і не під агрегатною функцією.
-- Виконуємо двічі поспіль, щоб порівняти результат.
-- =====================================================================
SELECT restaurant_id, dish_name, COUNT(*) AS кількість
FROM orders
GROUP BY restaurant_id;
-- Запуск 1:
-- restaurant_id | dish_name          | кількість
-- 1             | Борщ український   | 2
-- 2             | Піца Маргарита     | 3
-- 3             | Бургер класичний   | 1

SELECT restaurant_id, dish_name, COUNT(*) AS кількість
FROM orders
GROUP BY restaurant_id;
-- Запуск 2 (та сама база, той самий запит):
-- restaurant_id | dish_name          | кількість
-- 1             | Борщ український   | 2
-- 2             | Піца Маргарита     | 3
-- 3             | Бургер класичний   | 1
