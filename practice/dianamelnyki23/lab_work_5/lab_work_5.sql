-- Практична робота 5
-- Обмеження цілісності даних: NOT NULL, UNIQUE, CHECK, DEFAULT
-- Варіант 7: Фітнес-клуб

PRAGMA foreign_keys = ON;

ALTER TABLE clients RENAME TO clients_old;

CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone TEXT NOT NULL,
    birth_date TEXT NOT NULL
);

INSERT INTO clients
SELECT * FROM clients_old;

DROP TABLE clients_old;

ALTER TABLE clients RENAME TO clients_old;

CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone TEXT NOT NULL UNIQUE,
    birth_date TEXT NOT NULL
);

INSERT INTO clients
SELECT * FROM clients_old;

DROP TABLE clients_old;

ALTER TABLE memberships RENAME TO memberships_old;

CREATE TABLE memberships (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL,
    duration_days INTEGER NOT NULL,
    price REAL NOT NULL CHECK (price > 0)
);

INSERT INTO memberships
SELECT * FROM memberships_old;

DROP TABLE memberships_old;

ALTER TABLE memberships RENAME TO memberships_old;

CREATE TABLE memberships (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL,
    duration_days INTEGER NOT NULL DEFAULT 30,
    price REAL NOT NULL CHECK (price > 0)
);

INSERT INTO memberships
SELECT * FROM memberships_old;

DROP TABLE memberships_old;

UPDATE memberships
SET price = -50
WHERE id = 1;