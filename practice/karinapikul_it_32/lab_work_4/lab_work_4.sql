PRAGMA foreign_keys = ON;

CREATE TABLE memberships (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL,
    duration_days INTEGER NOT NULL,
    price REAL NOT NULL,
    description TEXT
);

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
    FOREIGN KEY (membership_id) REFERENCES memberships(id) ON DELETE RESTRICT,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE RESTRICT
);

INSERT INTO memberships (id, type, duration_days, price, description) VALUES
(1, 'Разовий', 1, 150.0, 'Одноразове відвідування'),
(2, 'Тижневий', 7, 500.0, 'Доступ на 7 днів'),
(3, 'Місячний', 30, 1200.0, 'Доступ на місяць'),
(4, 'Квартальний', 90, 3000.0, NULL),
(5, 'Піврічний', 180, 5200.0, NULL),
(6, 'Річний', 365, 9000.0, NULL),
(7, 'Пробний', 3, 450.0, NULL);

INSERT INTO clients (id, last_name, first_name, phone, birth_date) VALUES
(1, 'Шевченко', 'Олена', '+380501112233', '2005-03-15'),
(2, 'Ковальчук', 'Максим', '+380671234567', '2004-07-22'),
(3, 'Мельник', 'Анна', '+380931234567', '2006-01-10'),
(4, 'Бондар', 'Андрій', '+380991234567', '2003-11-05'),
(5, 'Ткаченко', 'Марія', '+380631234567', '2005-09-18'),
(6, 'Петренко', 'Дмитро', '+380731234567', '2004-05-27');

INSERT INTO membership_sales (id, membership_id, client_id, purchase_date, expiration_date) VALUES
(1, 1, 1, '2026-09-01', '2026-09-01'),
(2, 2, 2, '2026-09-02', '2026-09-08'),
(3, 3, 3, '2026-09-03', '2026-10-02'),
(4, 4, 1, '2026-09-05', '2026-12-03'),
(5, 5, 4, '2026-09-06', '2027-03-05'),
(6, 6, 5, '2026-09-07', '2027-09-07'),
(7, 3, 6, '2026-09-08', '2026-10-07'),
(8, 2, 1, '2026-09-10', '2026-09-16'),
(9, 3, 2, '2026-09-11', '2026-10-10'),
(10, 1, 3, '2026-09-12', '2026-09-12');
