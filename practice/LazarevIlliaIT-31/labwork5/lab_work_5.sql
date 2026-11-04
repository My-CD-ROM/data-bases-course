-- Підготовка: зняття попереднього NOT NULL для навчальної демонстрації
PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;
CREATE TABLE clients_new (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone TEXT NOT NULL,
    birth_date TEXT
);
INSERT INTO clients_new (id, last_name, first_name, phone, birth_date)
SELECT id, last_name, first_name, phone, birth_date FROM clients;
DROP TABLE clients;
ALTER TABLE clients_new RENAME TO clients;
COMMIT;
PRAGMA foreign_keys = ON;
PRAGMA foreign_key_check;

-- Завдання 1: NOT NULL
PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;
CREATE TABLE clients_new (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone TEXT NOT NULL,
    birth_date TEXT NOT NULL
);
INSERT INTO clients_new (id, last_name, first_name, phone, birth_date)
SELECT id, last_name, first_name, phone, birth_date FROM clients;
DROP TABLE clients;
ALTER TABLE clients_new RENAME TO clients;
COMMIT;
PRAGMA foreign_keys = ON;
PRAGMA foreign_key_check;

-- Перевірка: виконати окремо, прибравши --.
-- INSERT INTO clients (last_name, first_name, phone) VALUES ('Петренко', 'Олег', '+380670000007');
-- NOT NULL constraint failed: clients.birth_date

-- Завдання 2: UNIQUE
PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;
CREATE TABLE clients_new (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone TEXT NOT NULL UNIQUE,
    birth_date TEXT NOT NULL
);
INSERT INTO clients_new (id, last_name, first_name, phone, birth_date)
SELECT id, last_name, first_name, phone, birth_date FROM clients;
DROP TABLE clients;
ALTER TABLE clients_new RENAME TO clients;
COMMIT;
PRAGMA foreign_keys = ON;
PRAGMA foreign_key_check;

-- Перевірка: виконати окремо, прибравши --.
-- INSERT INTO clients (last_name, first_name, phone, birth_date) VALUES ('Петренко', 'Олег', (SELECT phone FROM clients WHERE id=1), '2001-04-12');
-- UNIQUE constraint failed: clients.phone

-- Завдання 3: CHECK
PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;
CREATE TABLE memberships_new (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL,
    duration_days INTEGER NOT NULL,
    price REAL NOT NULL CHECK (price > 0)
);
INSERT INTO memberships_new (id, type, duration_days, price)
SELECT id, type, duration_days, price FROM memberships;
DROP TABLE memberships;
ALTER TABLE memberships_new RENAME TO memberships;
COMMIT;
PRAGMA foreign_keys = ON;
PRAGMA foreign_key_check;

-- Перевірка: виконати окремо, прибравши --.
-- INSERT INTO memberships (type, duration_days, price) VALUES ('Тестовий неправильний', 30, -100);
-- CHECK constraint failed: price > 0

BEGIN TRANSACTION;
INSERT INTO memberships (type, duration_days, price) VALUES ('Тестовий правильний',30,1400);
SELECT * FROM memberships WHERE id=last_insert_rowid();
ROLLBACK;

-- Завдання 4: DEFAULT
PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;
CREATE TABLE memberships_new (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL,
    duration_days INTEGER NOT NULL DEFAULT 30,
    price REAL NOT NULL CHECK (price > 0)
);
INSERT INTO memberships_new (id, type, duration_days, price)
SELECT id, type, duration_days, price FROM memberships;
DROP TABLE memberships;
ALTER TABLE memberships_new RENAME TO memberships;
COMMIT;
PRAGMA foreign_keys = ON;
PRAGMA foreign_key_check;

BEGIN TRANSACTION;
INSERT INTO memberships(type,price) VALUES('Тестовий місячний',1400);
SELECT type,duration_days,price FROM memberships WHERE id=last_insert_rowid();
ROLLBACK;

-- Завдання 5: виконати окремо, прибравши --.
-- UPDATE memberships SET price=-50 WHERE id=1;
-- CHECK constraint failed: price > 0

SELECT id,type,price FROM memberships WHERE id=1;
PRAGMA foreign_keys;
PRAGMA foreign_key_check;
PRAGMA integrity_check;
SELECT 'memberships' AS table_name,COUNT(*) AS row_count FROM memberships
UNION ALL SELECT 'clients',COUNT(*) FROM clients
UNION ALL SELECT 'membership_sales',COUNT(*) FROM membership_sales;
