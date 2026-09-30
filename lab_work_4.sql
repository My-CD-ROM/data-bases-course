PRAGMA foreign_keys = ON;

CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    phone TEXT NOT NULL,
    email TEXT
);

CREATE TABLE bookings (
    id INTEGER PRIMARY KEY,
    room_id INTEGER NOT NULL,
    client_id INTEGER NOT NULL,
    check_in_date TEXT NOT NULL,
    check_out_date TEXT NOT NULL,
    total_price REAL NOT NULL,
    FOREIGN KEY (room_id) REFERENCES rooms (id) ON DELETE RESTRICT,
    FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE CASCADE
);

INSERT INTO clients (full_name, phone, email) VALUES
    ('Шевченко Андрій Петрович', '+380501112233', 'andriy.shev@gmail.com'),
    ('Коваленко Оксана Василівна', '+380672223344', 'oksana.kov@ukr.net'),
    ('Мельник Дмитро Олегович', '+380933334455', 'dmitro.m@gmail.com'),
    ('Бондаренко Ірина Сергіївна', '+380504445566', 'iryna.b@gmail.com'),
    ('Лисенко Максим Павлович', '+380675556677', 'm.lysenko@gmail.com'),
    ('Павленко Наталія Іванівна', '+380936667788', 'natali.p@ukr.net');

    INSERT INTO bookings (room_id, client_id, check_in_date, check_out_date, total_price) VALUES
    (1, 1, '2026-10-01', '2026-10-05', 4800.0),
    (2, 2, '2026-10-02', '2026-10-06', 7200.0),
    (3, 3, '2026-10-03', '2026-10-07', 12800.0),
    (1, 4, '2026-10-06', '2026-10-08', 2400.0),
    (4, 5, '2026-10-10', '2026-10-15', 14000.0),
    (5, 6, '2026-10-12', '2026-10-18', 27000.0),
    (2, 1, '2026-10-15', '2026-10-18', 5400.0),
    (7, 3, '2026-10-20', '2026-10-22', 1800.0),
    (3, 4, '2026-10-22', '2026-10-25', 9600.0),
    (4, 2, '2026-10-25', '2026-10-30', 14000.0);

    INSERT INTO bookings (room_id, client_id, check_in_date, check_out_date, total_price)
VALUES (9999, 1, '2026-11-01', '2026-11-03', 2500.0);