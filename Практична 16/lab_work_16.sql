-- Практична робота 16
-- Створення та використання індексів SQLite
-- Виконала: Вовк Марія, група І-23

-- 1. Перевірка кількості записів
SELECT COUNT(*) AS total_books
FROM books;

-- 2. Перевірка дублікатів
SELECT title, author, COUNT(*) AS total
FROM books
GROUP BY title, author
HAVING COUNT(*) > 1;

-- 3. Перевірка наявних індексів
PRAGMA index_list(books);

-- 4. Перевірка пошуку за назвою
EXPLAIN QUERY PLAN
SELECT * FROM books
WHERE title = 'Кобзар';

-- 5. Створення індексу за автором
CREATE INDEX IF NOT EXISTS idx_books_author
ON books(author);

-- 6. Перевірка пошуку за автором
EXPLAIN QUERY PLAN
SELECT * FROM books
WHERE author = 'Іван Франко';

-- 7. Створення індексу за роком видання
CREATE INDEX IF NOT EXISTS idx_books_year
ON books(publication_year);

-- 8. Перевірка пошуку за роком
EXPLAIN QUERY PLAN
SELECT * FROM books
WHERE publication_year = 1883;

-- 9. Створення складеного індексу
CREATE INDEX IF NOT EXISTS idx_books_author_year
ON books(author, publication_year);

-- 10. Перевірка складеного індексу
EXPLAIN QUERY PLAN
SELECT * FROM books
WHERE author = 'Іван Франко'
AND publication_year = 1883;

-- 11. Перевірка всіх індексів
PRAGMA index_list(books);

-- 12. Перегляд SQL-опису індексів
SELECT name, sql
FROM sqlite_master
WHERE type = 'index'
AND tbl_name = 'books';

-- 13. Перевірка всіх книг
SELECT * FROM books
ORDER BY id;