CREATE TABLE restaurants (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT,
    category TEXT
);

CREATE TABLE clients (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name TEXT NOT NULL,
    phone TEXT UNIQUE
);

CREATE TABLE orders (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    restaurant_id INTEGER,
    client_id INTEGER,
    dish_name TEXT,
    price REAL CHECK (price > 0),
    order_date TEXT,
    status TEXT NOT NULL DEFAULT 'Нове',
    price_with_service NUMERIC GENERATED ALWAYS AS (ROUND(price::numeric * 1.1, 2)) STORED,
    is_delivered BOOLEAN GENERATED ALWAYS AS (status = 'Доставлено') STORED,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE RESTRICT,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE SET NULL
);

SELECT setval(pg_get_serial_sequence('restaurants', 'id'), (SELECT MAX(id) FROM restaurants));
SELECT setval(pg_get_serial_sequence('clients', 'id'), (SELECT MAX(id) FROM clients));
SELECT setval(pg_get_serial_sequence('orders', 'id'), (SELECT MAX(id) FROM orders));

INSERT INTO restaurants (name, category) VALUES ('Тестовий ресторан', 'Тест') RETURNING id;
INSERT INTO clients (full_name, phone) VALUES ('Тестовий Клієнт', '+380500000000') RETURNING id;
INSERT INTO orders (restaurant_id, client_id, dish_name, price, order_date)
VALUES (1, 1, 'Тестова страва', 100, '2026-09-20') RETURNING id, status, price_with_service, is_delivered;

SELECT COUNT(*) AS restaurants_count FROM restaurants;
SELECT COUNT(*) AS clients_count FROM clients;
SELECT COUNT(*) AS orders_count FROM orders;

INSERT INTO orders (restaurant_id, client_id, dish_name, price, order_date)
VALUES (9999, 1, 'Тест', 100, '2026-09-20');