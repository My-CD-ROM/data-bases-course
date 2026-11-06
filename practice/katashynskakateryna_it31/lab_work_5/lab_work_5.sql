PRAGMA foreign_keys = ON;

ALTER TABLE viewers RENAME TO viewers_old;

CREATE TABLE viewers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT
);

INSERT INTO viewers (id, last_name, first_name, email, phone)
SELECT id, last_name, first_name, email, phone
FROM viewers_old;

DROP TABLE viewers_old;

INSERT INTO viewers (first_name, email, phone)
VALUES ('Олег', 'oleh.test@gmail.com', '+380679999999');

ALTER TABLE viewers RENAME TO viewers_old;

CREATE TABLE viewers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT
);

INSERT INTO viewers (id, last_name, first_name, email, phone)
SELECT id, last_name, first_name, email, phone
FROM viewers_old;

DROP TABLE viewers_old;


INSERT INTO viewers (last_name, first_name, email, phone)
VALUES (
    'Коваль',
    'Олег',
    'anna.koval@gmail.com',
    '+380679999999'
);

ALTER TABLE movies RENAME TO movies_old;

CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    genre TEXT NOT NULL,
    duration_min INTEGER NOT NULL CHECK (duration_min > 0),
    year INTEGER NOT NULL,
    age_rating INTEGER
);

INSERT INTO movies (id, title, genre, duration_min, year, age_rating)
SELECT id, title, genre, duration_min, year, age_rating
FROM movies_old;

DROP TABLE movies_old;

INSERT INTO movies (title, genre, duration_min, year, age_rating)
VALUES (
    'Тестовий фільм',
    'драма',
    0,
    2026,
    12
);

INSERT INTO movies (title, genre, duration_min, year, age_rating)
VALUES (
    'Тестовий фільм',
    'драма',
    120,
    2026,
    12
);

ALTER TABLE viewers RENAME TO viewers_old;

CREATE TABLE viewers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT DEFAULT 'не вказано'
);

INSERT INTO viewers (id, last_name, first_name, email, phone)
SELECT id, last_name, first_name, email, phone
FROM viewers_old;

DROP TABLE viewers_old;

INSERT INTO viewers (last_name, first_name, email)
VALUES (
    'Іваненко',
    'Олексій',
    'oleksii.ivanenko@gmail.com'
);

SELECT *
FROM viewers
WHERE email = 'oleksii.ivanenko@gmail.com';

UPDATE movies
SET duration_min = -10
WHERE title = 'Інтерстеллар';

SELECT sql
FROM sqlite_master
WHERE type = 'table'
  AND name IN ('movies', 'viewers');

SELECT * FROM movies;
SELECT * FROM viewers;