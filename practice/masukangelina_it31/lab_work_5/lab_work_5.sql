-- Практична робота 5
-- Обмеження цілісності даних: NOT NULL, UNIQUE, CHECK, DEFAULT
-- Варіант 1: Бібліотека


-- Завдання 1. NOT NULL для books.genre

ALTER TABLE books RENAME TO books_old;

CREATE TABLE books (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    publication_year INTEGER NOT NULL,
    genre TEXT NOT NULL,
    copies_count INTEGER NOT NULL
);

INSERT INTO books
SELECT * FROM books_old;

DROP TABLE books_old;


-- Завдання 2. UNIQUE для readers.email

ALTER TABLE readers RENAME TO readers_old;

CREATE TABLE readers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    registration_date TEXT NOT NULL
);

INSERT INTO readers
SELECT * FROM readers_old;

DROP TABLE readers_old;


-- Завдання 3. CHECK для books.copies_count

ALTER TABLE books RENAME TO books_old;

CREATE TABLE books (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    publication_year INTEGER NOT NULL,
    genre TEXT NOT NULL,
    copies_count INTEGER NOT NULL CHECK (copies_count >= 0)
);

INSERT INTO books
SELECT * FROM books_old;

DROP TABLE books_old;


-- Завдання 4. DEFAULT для books.copies_count

ALTER TABLE books RENAME TO books_old;

CREATE TABLE books (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    publication_year INTEGER NOT NULL,
    genre TEXT NOT NULL,
    copies_count INTEGER NOT NULL DEFAULT 1 CHECK (copies_count >= 0)
);

INSERT INTO books
SELECT * FROM books_old;

DROP TABLE books_old;


-- Завдання 5. Перевірка NOT NULL через UPDATE

UPDATE books
SET genre = NULL
WHERE id = 1;