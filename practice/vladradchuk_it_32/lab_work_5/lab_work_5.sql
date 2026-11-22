-- Практична робота 5. Варіант 3 — Кінотеатр

-- 1. Додаємо NOT NULL для email глядачів
PRAGMA foreign_keys = OFF;

CREATE TABLE viewers_new (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT
);

INSERT INTO viewers_new SELECT * FROM viewers;
DROP TABLE viewers;
ALTER TABLE viewers_new RENAME TO viewers;

PRAGMA foreign_keys = ON;

-- 2. Додаємо UNIQUE для email
PRAGMA foreign_keys = OFF;

CREATE TABLE viewers_new (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT
);

INSERT INTO viewers_new SELECT * FROM viewers;
DROP TABLE viewers;
ALTER TABLE viewers_new RENAME TO viewers;

PRAGMA foreign_keys = ON;

-- 3. Додаємо CHECK для тривалості фільму
PRAGMA foreign_keys = OFF;

CREATE TABLE movies_new (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    genre TEXT NOT NULL,
    duration_min INTEGER NOT NULL CHECK (duration_min > 0),
    year INTEGER NOT NULL,
    age_rating INTEGER NOT NULL
);

INSERT INTO movies_new SELECT * FROM movies;
DROP TABLE movies;
ALTER TABLE movies_new RENAME TO movies;

PRAGMA foreign_keys = ON;

-- 4. Додаємо DEFAULT для статусу фільму
PRAGMA foreign_keys = OFF;

CREATE TABLE movies_new (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    genre TEXT NOT NULL,
    duration_min INTEGER NOT NULL CHECK (duration_min > 0),
    year INTEGER NOT NULL,
    age_rating INTEGER NOT NULL,
    status TEXT NOT NULL DEFAULT 'у прокаті'
);

INSERT INTO movies_new (id, title, genre, duration_min, year, age_rating)
SELECT id, title, genre, duration_min, year, age_rating FROM movies;

DROP TABLE movies;
ALTER TABLE movies_new RENAME TO movies;

PRAGMA foreign_keys = ON;

-- 5. Перевірка NOT NULL
INSERT INTO viewers (last_name, first_name, phone)
VALUES ('Тестов', 'Тест', '+380000000000');

-- 6. Перевірка UNIQUE
INSERT INTO viewers (last_name, first_name, email, phone)
SELECT 'Тестов', 'Тест', email, '+380000000000'
FROM viewers LIMIT 1;

-- 7. Перевірка CHECK
UPDATE movies SET duration_min = -10 WHERE id = 1;

-- Коректне оновлення
UPDATE movies SET duration_min = 120 WHERE id = 1;

-- 8. Перевірка DEFAULT
INSERT INTO movies (title, genre, duration_min, year, age_rating)
VALUES ('Тестовий фільм', 'Комедія', 100, 2026, 12);

SELECT title, status
FROM movies
WHERE title = 'Тестовий фільм';

-- 9. Перевірка NOT NULL через UPDATE
UPDATE viewers SET email = NULL WHERE id = 1;