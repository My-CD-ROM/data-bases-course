PRAGMA foreign_keys = ON;

-- Таблиця-вимір 2: клієнти
CREATE TABLE IF NOT EXISTS clients (
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT,
    phone TEXT,
    registration_date TEXT
);

-- Фактова таблиця: замовлення (зв'язує products і clients)
CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL,
    client_id INTEGER,
    order_date TEXT NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE RESTRICT,
    FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE SET NULL
);

INSERT INTO clients (full_name, email, phone, registration_date) VALUES
    ('Олена Ковальчук', 'olena.k@mail.com', '0671234567', '2025-11-10'),
    ('Максим Гриценко', 'maks.g@mail.com', '0501234567', '2025-12-02'),
    ('Ірина Бондар', 'iryna.b@mail.com', '0631234567', '2026-01-15'),
    ('Андрій Кравець', 'andriy.k@mail.com', '0991234567', '2026-02-20'),
    ('Наталія Шевчук', 'natalia.s@mail.com', '0961234567', '2026-03-05');

INSERT INTO orders (product_id, client_id, order_date, quantity) VALUES
    (1, 1, '2026-09-01', 2),
    (2, 2, '2026-09-02', 1),
    (3, 1, '2026-09-03', 1),
    (4, 3, '2026-09-04', 1),
    (5, 4, '2026-09-05', 2),
    (6, 2, '2026-09-06', 1),
    (1, 5, '2026-09-07', 3),
    (2, 3, '2026-09-08', 1),
    (6, 1, '2026-09-09', 1),
    (3, 4, '2026-09-10', 2);
