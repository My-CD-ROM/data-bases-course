-- База прокату спорядження для прикладів розділу «Теорія» Практики 23.
-- Виконайте файл в окремій порожній базі (наприклад, gear_demo), а не в базі свого варіанта.

DROP TABLE IF EXISTS rentals, customers, gear CASCADE;
CREATE TABLE gear (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    daily_price NUMERIC(8, 2) NOT NULL,
    in_stock INTEGER NOT NULL
);
CREATE TABLE customers (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name TEXT NOT NULL,
    phone TEXT
);
CREATE TABLE rentals (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gear_id INTEGER NOT NULL REFERENCES gear(id),
    customer_id INTEGER NOT NULL REFERENCES customers(id),
    qty INTEGER NOT NULL,
    rent_date DATE NOT NULL
);
INSERT INTO gear (name, daily_price, in_stock) VALUES
    ('Каремат', 40, 10),
    ('Спальник', 120, 5),
    ('Намет двомісний', 250, 3),
    ('Казанок', 60, 0),
    ('Трекінгові палиці', 80, 4);
INSERT INTO customers (full_name, phone) VALUES
    ('Олег Дмитренко', '+380501234567'),
    ('Марта Гнатюк', '+380671234567');
INSERT INTO rentals (gear_id, customer_id, qty, rent_date) VALUES
    (2, 1, 1, '2026-09-20'),
    (1, 2, 2, '2026-10-03');
