-- Завдання 1

PRAGMA foreign_keys = ON;


-- Завдання 2   

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
    FOREIGN KEY (membership_id)
        REFERENCES memberships(id)
        ON DELETE RESTRICT,
    FOREIGN KEY (client_id)
        REFERENCES clients(id)
        ON DELETE RESTRICT
);


-- Завдання 3

INSERT INTO clients (last_name, first_name, phone, birth_date) VALUES
    ('Шевченко', 'Олена', '0671112233', '1998-04-12'),
    ('Коваленко', 'Максим', '0682223344', '1995-09-23'),
    ('Бондаренко', 'Анна', '0633334455', '2001-02-17'),
    ('Мельник', 'Андрій', '0664445566', '1992-11-08'),
    ('Ткаченко', 'Марія', '0975556677', '1999-06-30'),
    ('Лисенко', 'Дмитро', '0506667788', '1996-12-05');

INSERT INTO membership_sales
    (membership_id, client_id, purchase_date, expiration_date)
VALUES
    (1, 1, '2026-01-10', '2026-02-08'),
    (2, 2, '2026-01-15', '2026-02-13'),
    (3, 3, '2026-02-01', '2026-05-01'),
    (1, 4, '2026-02-10', '2026-03-11'),
    (4, 1, '2026-03-05', '2026-09-01'),
    (2, 5, '2026-03-20', '2026-04-18'),
    (5, 6, '2026-04-02', '2027-04-02'),
    (3, 2, '2026-04-15', '2026-07-13'),
    (6, 3, '2026-05-01', '2026-05-30'),
    (4, 5, '2026-05-12', '2026-11-08');


-- Завдання 4

INSERT INTO membership_sales
    (membership_id, client_id, purchase_date, expiration_date)
VALUES
    (9999, 1, '2026-09-23', '2026-10-23');


-- Завдання 5

SELECT
    membership_sales.id,
    memberships.type,
    clients.last_name,
    clients.first_name,
    membership_sales.purchase_date,
    membership_sales.expiration_date
FROM membership_sales
JOIN memberships
    ON membership_sales.membership_id = memberships.id
JOIN clients
    ON membership_sales.client_id = clients.id;
