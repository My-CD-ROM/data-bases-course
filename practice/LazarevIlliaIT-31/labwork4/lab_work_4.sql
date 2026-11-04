PRAGMA foreign_keys = ON;

CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone TEXT NOT NULL,
    birth_date TEXT NOT NULL
);

INSERT INTO clients (id, last_name, first_name, phone, birth_date)
VALUES
    (1, 'Шевченко', 'Олександр', '+380671112233', '2005-03-15'),
    (2, 'Коваленко', 'Андрій', '+380682223344', '2004-07-21'),
    (3, 'Мельник', 'Максим', '+380933334455', '2006-01-10'),
    (4, 'Бондаренко', 'Дмитро', '+380954445566', '2003-11-05'),
    (5, 'Ткаченко', 'Артем', '+380966556677', '2005-09-18'),
    (6, 'Іваненко', 'Роман', '+380977667788', '2004-12-27');

CREATE TABLE membership_sales (
    id INTEGER PRIMARY KEY,
    membership_id INTEGER NOT NULL,
    client_id INTEGER NOT NULL,
    purchase_date TEXT NOT NULL,
    expiration_date TEXT NOT NULL,

    FOREIGN KEY (membership_id)
        REFERENCES memberships(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (client_id)
        REFERENCES clients(id)
        ON DELETE CASCADE
);

INSERT INTO membership_sales
    (id, membership_id, client_id, purchase_date, expiration_date)
VALUES
    (1, 1, 1, '2026-09-01', '2026-10-01'),
    (2, 2, 2, '2026-09-03', '2026-12-02'),
    (3, 1, 3, '2026-09-05', '2026-10-05'),
    (4, 3, 4, '2026-09-07', '2027-03-06'),
    (5, 4, 5, '2026-09-10', '2027-09-10'),
    (6, 1, 6, '2026-09-12', '2026-10-12'),
    (7, 2, 1, '2026-10-01', '2026-12-30'),
    (8, 3, 2, '2026-10-03', '2027-04-01'),
    (9, 1, 4, '2026-10-05', '2026-11-04'),
    (10, 4, 3, '2026-10-07', '2027-10-07');