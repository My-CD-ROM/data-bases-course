
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS restaurants;

CREATE TABLE restaurants (
    id INTEGER PRIMARY KEY,
    name TEXT,
    category TEXT
);

INSERT INTO restaurants (id, name, category) VALUES
    (1, 'Смак', 'Українська'),
    (2, 'Pizza House', 'Піца'),
    (3, 'Burger Point', 'Бургери'),
    (4, 'Sushi Time', 'Суші'),
    (5, 'Pasta Place', 'Паста'),
    (6, 'Fresh Food', 'Салати');

CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    full_name TEXT,
    phone TEXT
);

INSERT INTO clients (id, full_name, phone) VALUES
    (1, 'Олександр Петренко', '+380501112233'),
    (2, 'Ірина Коваль', '+380672223344'),
    (3, 'Андрій Шевченко', '+380933334455'),
    (4, 'Марія Бондаренко', '+380504445566'),
    (5, 'Дмитро Мельник', '+380675556677'),
    (6, 'Наталія Гриценко', '+380639998877');

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

INSERT INTO orders (restaurant_id, client_id, dish_name, price, order_date) VALUES
    (1, 1, 'Борщ український', 120.00, '2026-09-01'),
    (2, 2, 'Піца Маргарита', 220.00, '2026-09-01'),
    (3, 3, 'Бургер класичний', 189.00, '2026-09-02'),
    (1, 4, 'Вареники', 140.00, '2026-09-03'),
    (2, 1, 'Піца Пепероні', 240.00, '2026-09-04'),
    (4, 5, 'Суші Філадельфія', 280.00, '2026-09-04'),
    (5, 2, 'Паста Карбонара', 210.00, '2026-09-05'),
    (6, 6, 'Цезар з куркою', 175.00, '2026-09-05'),
    (3, 4, 'Бургер з беконом', 199.00, '2026-09-06'),
    (5, 3, 'Лазанья', 230.00, '2026-09-06');

INSERT INTO orders (restaurant_id, client_id, dish_name, price, order_date)
VALUES (9999, 1, 'Тестова страва', 100.00, '2026-09-07');
