-- Практика 5. Обмеження цілісності даних: NOT NULL, UNIQUE, CHECK, DEFAULT
-- Варіант 8. Служба доставки їжі

PRAGMA foreign_keys = ON;

-- =====================================================================
-- 0. Вихідний стан (те, що мало лишитись після Практики 4):
--    дві таблиці-виміри без жодних обмежень цілісності, крім PK і FK,
--    та фактова таблиця, що їх з'єднує.
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


-- =====================================================================
-- ЗАВДАННЯ 1. Додаємо NOT NULL до clients.full_name
-- (стовпець, який досі не мав жодного обмеження, а за змістом завжди
-- повинен бути заповнений)
--
-- ВАЖЛИВО: clients — таблиця, на яку посилається FK з orders
-- (ON DELETE SET NULL). Якщо перестворювати її при увімкненому
-- PRAGMA foreign_keys, DROP TABLE clients_old трактується як видалення
-- всіх її рядків і реально запускає ON DELETE SET NULL для orders —
-- усі наявні client_id обнуляться ще ДО того, як дійде черга до
-- Завдання 5. Тому на час перестворення таблиці, яка є "батьківською"
-- для чужого FK, перевірку тимчасово вимикаємо, а одразу після
-- перестворення повертаємо назад.
-- =====================================================================
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

-- Перевірка порушення: пропускаємо full_name
INSERT INTO clients (id, phone) VALUES (5, '+380671110000');
-- Очікувана помилка:
-- Error: NOT NULL constraint failed: clients.full_name


-- =====================================================================
-- ЗАВДАННЯ 2. Додаємо UNIQUE до clients.phone
-- (інший стовпець, значення якого змістовно не повинні повторюватись)
-- =====================================================================
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

-- Перевірка порушення: номер телефону, що вже є в базі
INSERT INTO clients (id, full_name, phone) VALUES (5, 'Тестовий Клієнт', '+380501112233');
-- Очікувана помилка:
-- Error: UNIQUE constraint failed: clients.phone


-- =====================================================================
-- ЗАВДАННЯ 3. Додаємо CHECK до orders.price
-- (числовий стовпець зі змістовним діапазоном значень)
-- =====================================================================
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

-- Перевірка 1: порушення (від'ємна ціна) -> очікується помилка
INSERT INTO orders (restaurant_id, client_id, dish_name, price, order_date)
VALUES (1, 1, 'Тестова страва', -50.00, '2026-09-05');
-- Очікувана помилка:
-- Error: CHECK constraint failed: price > 0

-- Перевірка 2: коректне значення -> виконується без помилок
INSERT INTO orders (restaurant_id, client_id, dish_name, price, order_date)
VALUES (2, 2, 'Салат Цезар', 159.00, '2026-09-06');


-- =====================================================================
-- ЗАВДАННЯ 4. Додаємо DEFAULT до orders.status (разом з NOT NULL)
-- (стовпець зі змістовним значенням "за замовчуванням")
-- =====================================================================
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

-- Перевірка: вставляємо рядок, не вказуючи status
INSERT INTO orders (restaurant_id, client_id, dish_name, price, order_date)
VALUES (3, 3, 'Піца Гавайська', 210.00, '2026-09-07');

-- Підтвердження підставленого значення
SELECT id, dish_name, status FROM orders WHERE dish_name = 'Піца Гавайська';
-- Очікуваний результат: status = 'Нове'


-- =====================================================================
-- ЗАВДАННЯ 5. Порушення обмеження через UPDATE, а не INSERT
-- Беремо CHECK (price > 0) і порушуємо його оновленням наявного рядка
-- =====================================================================
UPDATE orders SET price = -10.0 WHERE id = 1;
-- Очікувана помилка:
-- Error: CHECK constraint failed: price > 0
-- Висновок: обмеження CHECK діє однаково і при INSERT, і при UPDATE.
