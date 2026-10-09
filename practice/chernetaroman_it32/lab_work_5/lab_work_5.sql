PRAGMA foreign_keys = ON;

-- Завдання 1

ALTER TABLE memberships RENAME TO memberships_old;

CREATE TABLE memberships (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL,
    duration_days INTEGER,
    price REAL
);

INSERT INTO memberships
SELECT * FROM memberships_old;

DROP TABLE memberships_old;

INSERT INTO memberships (duration_days, price)
VALUES (10, 500);


-- Завдання 2

ALTER TABLE memberships RENAME TO memberships_old;

CREATE TABLE memberships (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL UNIQUE,
    duration_days INTEGER,
    price REAL
);

INSERT INTO memberships
SELECT * FROM memberships_old;

DROP TABLE memberships_old;

INSERT INTO memberships (type, duration_days, price)
VALUES ('Місячний', 30, 1500);


-- Завдання 3

ALTER TABLE memberships RENAME TO memberships_old;

CREATE TABLE memberships (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL UNIQUE,
    duration_days INTEGER,
    price REAL CHECK (price > 0)
);

INSERT INTO memberships
SELECT * FROM memberships_old;

DROP TABLE memberships_old;

INSERT INTO memberships (type, duration_days, price)
VALUES ('Тестовий', 10, -100);

INSERT INTO memberships (type, duration_days, price)
VALUES ('Тестовий', 10, 500);

DELETE FROM memberships
WHERE type = 'Тестовий';


-- Завдання 4

ALTER TABLE memberships RENAME TO memberships_old;

CREATE TABLE memberships (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL UNIQUE,
    duration_days INTEGER DEFAULT 1,
    price REAL CHECK (price > 0)
);

INSERT INTO memberships
SELECT * FROM memberships_old;

DROP TABLE memberships_old;

INSERT INTO memberships (type, price)
VALUES ('Одноденний', 200);

SELECT *
FROM memberships
WHERE type = 'Одноденний';


-- Завдання 5

UPDATE memberships
SET price = -500
WHERE type = 'Місячний';


-- Завдання 6

SELECT *
FROM memberships;