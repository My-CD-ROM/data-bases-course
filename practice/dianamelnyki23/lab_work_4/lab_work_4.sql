PRAGMA foreign_keys = ON;

CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone TEXT NOT NULL,
    birth_date TEXT NOT NULL
);

CREATE TABLE membership_sales (
    id INTEGER PRIMARY KEY,
    membership_id INTEGER NOT NULL,
    client_id INTEGER NOT NULL,
    purchase_date TEXT NOT NULL,
    expiration_date TEXT NOT NULL,
    FOREIGN KEY (membership_id) REFERENCES memberships(id)
        ON DELETE RESTRICT,
    FOREIGN KEY (client_id) REFERENCES clients(id)
        ON DELETE CASCADE
);

INSERT INTO clients (last_name, first_name, phone, birth_date) VALUES
    ('Мельник', 'Діана', '+380671234567', '2008-01-02'),
    ('Шевченко', 'Анна', '+380931112233', '2007-05-14'),
    ('Коваль', 'Максим', '+380501234567', '2006-09-21'),
    ('Бондар', 'Олександр', '+380631112244', '2005-03-18'),
    ('Ткаченко', 'Софія', '+380991234567', '2008-07-30'),
    ('Романюк', 'Іван', '+380681112233', '2004-11-12');

INSERT INTO membership_sales
    (membership_id, client_id, purchase_date, expiration_date)
VALUES
    (1, 1, '2026-09-01', '2026-09-01'),
    (2, 2, '2026-09-02', '2026-09-08'),
    (3, 3, '2026-09-03', '2026-10-03'),
    (4, 4, '2026-09-04', '2026-12-03'),
    (5, 5, '2026-09-05', '2027-03-04'),
    (6, 6, '2026-09-06', '2027-09-06'),
    (3, 1, '2026-09-07', '2026-10-07'),
    (2, 3, '2026-09-08', '2026-09-14'),
    (4, 5, '2026-09-09', '2026-12-08'),
    (6, 2, '2026-09-10', '2027-09-10');