DROP TABLE IF EXISTS membership_sales;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS memberships;
CREATE TABLE memberships (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL,
    duration_days INTEGER,
    price REAL
);
CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone TEXT,
    birth_date TEXT
);
CREATE TABLE membership_sales (
    id INTEGER PRIMARY KEY,
    membership_id INTEGER REFERENCES memberships(id),
    client_id INTEGER REFERENCES clients(id),
    purchase_date TEXT NOT NULL,
    expiration_date TEXT
);
INSERT INTO memberships VALUES (1, 'розовий (1 місяць)', 30, 899.0);
INSERT INTO memberships VALUES (2, 'стандарт (3 місяці)', 90, 2399.0);
INSERT INTO memberships VALUES (3, 'річний', 365, 7999.0);
INSERT INTO memberships VALUES (4, 'безлімітний груповий', 30, 1299.0);
INSERT INTO memberships VALUES (5, 'тренажерна зала', 30, 799.0);
INSERT INTO memberships VALUES (6, 'basic', 30, 649.0);
INSERT INTO memberships VALUES (7, 'premium', 90, 2899.0);
INSERT INTO memberships VALUES (8, 'студентський', 30, 549.0);
INSERT INTO memberships VALUES (9, 'сімейний', 30, 1699.0);
INSERT INTO memberships VALUES (10, 'разовий візит', 1, 150.0);
INSERT INTO memberships VALUES (11, 'safe (день)', 1, 200.0);
INSERT INTO memberships VALUES (12, 'VIP річний', 365, 12999.0);
INSERT INTO clients VALUES (1, 'Руденко', 'Роман', '+380955000001', '2005-02-27');
INSERT INTO clients VALUES (2, 'Мельник', 'Тетяна', '+380955000002', '1986-12-12');
INSERT INTO clients VALUES (3, 'Бондаренко', 'Тарас', '+380955000003', '1996-02-22');
INSERT INTO clients VALUES (4, 'Кравець', 'Юлія', '+380955000004', '1986-07-09');
INSERT INTO clients VALUES (5, 'Бондаренко', 'Софія', '+380955000005', '1987-11-07');
INSERT INTO clients VALUES (6, 'Захарченко', 'Оксана', '+380955000006', '1986-06-08');
INSERT INTO clients VALUES (7, 'Шевченко', 'Ірина', '+380955000007', '1987-09-07');
INSERT INTO clients VALUES (8, 'Поліщук', 'Тарас', '+380955000008', '1995-03-26');
INSERT INTO clients VALUES (9, 'Гриценко', 'Тетяна', '+380955000009', '1989-03-18');
INSERT INTO clients VALUES (10, 'Ткаченко', 'Марія', '+380955000010', '1985-03-01');
INSERT INTO clients VALUES (11, 'Кравець', 'Ірина', '+380955000011', '2003-06-01');
INSERT INTO clients VALUES (12, 'Шевченко', 'Олег', '+380955000012', '1998-09-04');
INSERT INTO membership_sales VALUES (1, 12, 2, '2025-08-25', '2026-09-19');
INSERT INTO membership_sales VALUES (2, 2, 8, '2024-10-02', '2026-08-21');
INSERT INTO membership_sales VALUES (3, 1, 1, '2025-07-14', '2025-08-23');
INSERT INTO membership_sales VALUES (4, 8, 2, '2024-06-20', '2025-02-05');
INSERT INTO membership_sales VALUES (5, 5, 10, '2025-07-20', '2026-08-17');
INSERT INTO membership_sales VALUES (6, 10, 7, '2024-12-04', '2025-07-15');
INSERT INTO membership_sales VALUES (7, 4, 7, '2025-08-13', '2026-12-04');
INSERT INTO membership_sales VALUES (8, 6, 7, '2025-11-09', '2026-03-22');
INSERT INTO membership_sales VALUES (9, 8, 2, '2024-02-03', '2026-02-24');
INSERT INTO membership_sales VALUES (10, 12, 6, '2024-09-02', '2026-11-04');
INSERT INTO membership_sales VALUES (11, 7, 6, '2025-12-02', '2026-10-10');
INSERT INTO membership_sales VALUES (12, 6, 2, '2024-03-22', '2026-04-28');
INSERT INTO membership_sales VALUES (13, 2, 6, '2025-02-25', '2026-10-08');
INSERT INTO membership_sales VALUES (14, 7, 9, '2024-10-22', '2026-01-06');
INSERT INTO membership_sales VALUES (15, 5, 12, '2025-06-12', '2025-03-28');
INSERT INTO membership_sales VALUES (16, 3, 10, '2025-02-05', '2025-02-24');
INSERT INTO membership_sales VALUES (17, 9, 4, '2025-07-15', '2026-03-12');
INSERT INTO membership_sales VALUES (18, 5, 12, '2025-10-20', '2025-01-05');
INSERT INTO membership_sales VALUES (19, 3, 10, '2024-11-03', '2026-08-22');
INSERT INTO membership_sales VALUES (20, 7, 8, '2025-07-09', '2025-09-04');
