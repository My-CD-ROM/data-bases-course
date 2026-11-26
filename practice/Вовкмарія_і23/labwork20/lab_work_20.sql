
-- Практична робота 20
-- Створення та застосування Views у PostgreSQL
-- Виконала: Вовк Марія, група І-23
-- База даних: library_vovk

-- ==========================================
-- Завдання 1. Подання-фільтр
-- ==========================================

DROP MATERIALIZED VIEW IF EXISTS books_in_stock_mat;
DROP VIEW IF EXISTS books_with_readers;
DROP VIEW IF EXISTS books_in_stock;

CREATE VIEW books_in_stock AS
SELECT id, title, author, publication_year, genre, copies_count
FROM books
WHERE copies_count > 0;

SELECT * FROM books_in_stock;


-- ==========================================
-- Завдання 2. Подання завжди актуальне
-- ==========================================

-- Перегляд кількості книг до додавання
SELECT COUNT(*) AS books_before
FROM books_in_stock;

-- Додавання нової книги до базової таблиці
INSERT INTO books
    (id, title, author, publication_year, genre, copies_count)
SELECT
    COALESCE(MAX(id), 0) + 1,
    'Пригоди у бібліотеці',
    'Марія Вовк',
    2025,
    'Пригоди',
    3
FROM books;

-- Перевірка подання після INSERT
SELECT * FROM books_in_stock
WHERE title = 'Пригоди у бібліотеці';

SELECT COUNT(*) AS books_after
FROM books_in_stock;


-- ==========================================
-- Завдання 3. Запис через просте подання
-- ==========================================

INSERT INTO books_in_stock
    (id, title, author, publication_year, genre, copies_count)
SELECT
    COALESCE(MAX(id), 0) + 1,
    'Таємниці старої бібліотеки',
    'Олена Коваль',
    2024,
    'Детектив',
    2
FROM books;

-- Перевірка запису в базовій таблиці
SELECT *
FROM books
WHERE title = 'Таємниці старої бібліотеки';


-- ==========================================
-- Завдання 4. Матеріалізоване подання і REFRESH
-- ==========================================

CREATE MATERIALIZED VIEW books_in_stock_mat AS
SELECT id, title, author, publication_year, genre, copies_count
FROM books
WHERE copies_count > 0;

-- Кількість записів до додавання нової книги
SELECT COUNT(*) AS ordinary_view_count
FROM books_in_stock;

SELECT COUNT(*) AS materialized_view_count
FROM books_in_stock_mat;

-- Додавання нової книги в базову таблицю
INSERT INTO books
    (id, title, author, publication_year, genre, copies_count)
SELECT
    COALESCE(MAX(id), 0) + 1,
    'Світ книг',
    'Іван Петренко',
    2026,
    'Навчальна література',
    4
FROM books;

-- Звичайне подання вже бачить новий запис
SELECT COUNT(*) AS ordinary_view_count
FROM books_in_stock;

-- Матеріалізоване подання ще не бачить новий запис
SELECT COUNT(*) AS materialized_view_count
FROM books_in_stock_mat;

-- Оновлення матеріалізованого подання
REFRESH MATERIALIZED VIEW books_in_stock_mat;

-- Перевірка після оновлення
SELECT COUNT(*) AS materialized_view_count_after_refresh
FROM books_in_stock_mat;

SELECT *
FROM books_in_stock_mat
WHERE title = 'Світ книг';


-- ==========================================
-- Завдання 5. CREATE OR REPLACE VIEW
-- ==========================================

CREATE OR REPLACE VIEW books_in_stock AS
SELECT id, title, author, publication_year, genre, copies_count, is_modern
FROM books
WHERE copies_count > 0;

-- Перевірка зміненого подання
SELECT * FROM books_in_stock;


-- ==========================================
-- Завдання 6. Які подання можна змінювати
-- ==========================================

-- Створення подання з JOIN
CREATE VIEW books_with_readers AS
SELECT
    b.id AS book_id,
    b.title,
    b.author,
    r.id AS reader_id,
    r.name AS reader_name,
    l.loan_date,
    l.return_date
FROM books b
JOIN loans l ON b.id = l.book_id
JOIN readers r ON l.reader_id = r.id;

SELECT * FROM books_with_readers;

-- Спроба INSERT через подання з JOIN.
-- Виконати окремо, щоб побачити помилку PostgreSQL:
-- INSERT INTO books_with_readers
--     (book_id, title, author, reader_id, reader_name, loan_date)
-- VALUES
--     (1000, 'Тестова книга', 'Тестовий автор', 1, 'Тестовий читач', CURRENT_DATE);


-- Додавання WITH CHECK OPTION до простого подання
CREATE OR REPLACE VIEW books_in_stock AS
SELECT id, title, author, publication_year, genre, copies_count, is_modern
FROM books
WHERE copies_count > 0
WITH CHECK OPTION;

-- INSERT, який відповідає умові WHERE
INSERT INTO books_in_stock
    (id, title, author, publication_year, genre, copies_count)
SELECT
    COALESCE(MAX(id), 0) + 1,
    'Книга для перевірки',
    'Тестовий автор',
    2026,
    'Навчальна',
    5
FROM books;

-- Перевірка успішного додавання
SELECT *
FROM books_in_stock
WHERE title = 'Книга для перевірки';

-- INSERT, який не відповідає умові WHERE.
-- Виконати окремо, щоб побачити помилку WITH CHECK OPTION:
-- INSERT INTO books_in_stock
--     (id, title, author, publication_year, genre, copies_count)
-- SELECT
--     COALESCE(MAX(id), 0) + 1,
--     'Книга без примірників',
--     'Тестовий автор 2',
--     2026,
--     'Навчальна',
--     0
-- FROM books;

-- Перевірка базової таблиці
SELECT *
FROM books
WHERE title IN (
    'Пригоди у бібліотеці',
    'Таємниці старої бібліотеки',
    'Світ книг',
    'Книга для перевірки'
);

-- Кінець практичної роботи 20
