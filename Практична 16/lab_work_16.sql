
-- Практична робота №16
-- Імпорт даних із CSV у SQLite
-- Виконала: Вовк Марія Віталіївна, група І-23

-- 1. Перевірка кількості записів до імпорту
SELECT COUNT(*) AS total_books
FROM books;

-- 2. Створення проміжної таблиці
DROP TABLE IF EXISTS books_staging;

CREATE TABLE books_staging (
    title TEXT,
    author TEXT,
    publication_year INTEGER,
    genre TEXT,
    copies_count INTEGER
);

-- 3. Імпорт CSV виконується в SQLite CLI:
-- .mode csv
-- .import --skip 1 "Практична 16/v1_new_rows.csv" books_staging

-- 4. Перевірка імпортованих даних
SELECT * FROM books_staging;

-- 5. Перенесення даних до основної таблиці
INSERT OR IGNORE INTO books (
    title,
    author,
    publication_year,
    genre,
    copies_count
)
SELECT
    title,
    author,
    publication_year,
    genre,
    copies_count
FROM books_staging;

-- 6. Видалення проміжної таблиці
DROP TABLE books_staging;

-- 7. Перевірка кількості записів після імпорту
SELECT COUNT(*) AS total_books_after_import
FROM books;

-- 8. Перевірка нових книг
SELECT id, title, author
FROM books
WHERE id >= 10
ORDER BY id;

-- 9. Перегляд усіх книг
SELECT id, title, author, publication_year, genre, copies_count
FROM books
ORDER BY id;
