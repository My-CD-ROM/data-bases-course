PRAGMA foreign_keys = ON;

CREATE TABLE guests (
    id         INTEGER PRIMARY KEY,
    last_name  TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email      TEXT,
    phone      TEXT
);

CREATE TABLE bookings (
    id              INTEGER PRIMARY KEY,
    room_id         INTEGER NOT NULL,
    guest_id        INTEGER NOT NULL,
    check_in_date   TEXT NOT NULL,
    check_out_date  TEXT NOT NULL,
    FOREIGN KEY (room_id)  REFERENCES rooms (id)  ON DELETE RESTRICT,
    FOREIGN KEY (guest_id) REFERENCES guests (id) ON DELETE CASCADE
);

INSERT INTO guests (last_name, first_name, email, phone) VALUES
    ('Коваленко', 'Олена', 'kovalenko.o@example.com', '0671112233'),
    ('Шевченко', 'Андрій', 'shevchenko.a@example.com', '0502223344'),
    ('Бондаренко', 'Марія', 'bondarenko.m@example.com', '0633334455'),
    ('Ткаченко', 'Іван', 'tkachenko.i@example.com', '0684445566'),
    ('Мельник', 'Софія', 'melnyk.s@example.com', '0995556677'),
    ('Гриценко', 'Павло', 'grytsenko.p@example.com', '0666667788');

INSERT INTO bookings (room_id, guest_id, check_in_date, check_out_date) VALUES
    (1, 1, '2026-09-01', '2026-09-05'),
    (2, 2, '2026-09-02', '2026-09-04'),
    (3, 3, '2026-09-03', '2026-09-10'),
    (4, 4, '2026-09-05', '2026-09-08'),
    (5, 1, '2026-09-06', '2026-09-07'),
    (6, 5, '2026-09-10', '2026-09-15'),
    (1, 6, '2026-09-12', '2026-09-14'),
    (2, 3, '2026-09-15', '2026-09-18'),
    (3, 4, '2026-09-20', '2026-09-22'),
    (4, 2, '2026-09-21', '2026-09-25');

-- Завдання 4 (навмисна помилка, розкоментувати для перевірки):
-- INSERT INTO bookings (room_id, guest_id, check_in_date, check_out_date)
-- VALUES (9999, 1, '2026-09-25', '2026-09-26');

