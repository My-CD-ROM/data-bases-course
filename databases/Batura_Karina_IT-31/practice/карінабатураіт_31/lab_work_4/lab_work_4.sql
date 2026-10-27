PRAGMA foreign_keys = ON;

CREATE TABLE customers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT
);

CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    order_date TEXT NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE RESTRICT,
    FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
);

INSERT INTO customers (first_name, last_name, email, phone) VALUES
    ('Анна', 'Ковальчук', 'anna.k@gmail.com', '+380671234567'),
    ('Дмитро', 'Шевченко', 'dmitro.sh@gmail.com', '+380509876543'),
    ('Олена', 'Бойко', 'olena.b@ukr.net', '+380631112233'),
    ('Максим', 'Ткаченко', 'max.tk@gmail.com', '+380974445566'),
    ('Ірина', 'Мельник', 'iryna.m@gmail.com', '+380507778899'),
    ('Павло', 'Кравченко', 'pavel.k@ukr.net', '+380689990011');

INSERT INTO orders (product_id, customer_id, order_date, quantity) VALUES
    (1, 1, '2026-09-01', 1),
    (2, 1, '2026-09-02', 1),
    (3, 2, '2026-09-03', 2),
    (4, 3, '2026-09-05', 1),
    (1, 4, '2026-09-10', 1),
    (5, 5, '2026-09-12', 1),
    (2, 6, '2026-09-14', 3),
    (3, 2, '2026-09-15', 1),
    (4, 5, '2026-09-18', 1),
    (5, 3, '2026-09-20', 2);