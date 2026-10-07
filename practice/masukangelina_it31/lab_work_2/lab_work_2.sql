-- Практична робота №2
-- Варіант 1 — Бібліотека

-- Завдання 1
SELECT title, author, publication_year, genre
FROM books;

-- Завдання 2
SELECT title, author, publication_year
FROM books
WHERE publication_year > 1900;

-- Завдання 3
SELECT title, author, publication_year
FROM books
LIMIT 3;

-- Завдання 4
INSERT INTO books (title, author, publication_year, genre, copies_count)
VALUES ('Невідома книга', 'Невідомий автор', 2020, NULL, 2);

SELECT title, author, genre
FROM books
WHERE genre IS NULL;

SELECT title, author, genre
FROM books
WHERE genre IS NOT NULL;

-- Завдання 5
SELECT title, author, publication_year, copies_count
FROM books
WHERE publication_year > 1900
  AND copies_count >= 4;