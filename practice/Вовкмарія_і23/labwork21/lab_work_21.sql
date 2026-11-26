-- Практична робота 21. Написання функцій у PostgreSQL
-- База даних: library_vovk
-- Таблиця для основних завдань: books

-- =========================================================
-- Завдання 1. Скалярна функція з обчисленням
-- Обчислює кількість років від року видання до 2026 року.
-- =========================================================

CREATE OR REPLACE FUNCTION book_age(p_year INTEGER)
RETURNS INTEGER AS $$
BEGIN
    IF p_year IS NULL THEN
        RETURN NULL;
    END IF;

    RETURN 2026 - p_year;
END;
$$ LANGUAGE plpgsql;

SELECT
    title,
    publication_year,
    book_age(publication_year) AS book_age_years
FROM books;


-- =========================================================
-- Завдання 2. Скалярна функція з умовною логікою
-- =========================================================

CREATE OR REPLACE FUNCTION book_stock_category(p_count INTEGER)
RETURNS TEXT AS $$
BEGIN
    IF p_count IS NULL THEN
        RETURN 'не вказано';
    ELSIF p_count = 0 THEN
        RETURN 'немає в наявності';
    ELSIF p_count <= 3 THEN
        RETURN 'мало примірників';
    ELSIF p_count <= 7 THEN
        RETURN 'достатньо примірників';
    ELSE
        RETURN 'багато примірників';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT
    title,
    copies_count,
    book_stock_category(copies_count) AS stock_category
FROM books;

-- Перевірка граничних значень і NULL:
SELECT
    value AS copies_count,
    book_stock_category(value) AS category
FROM (
    VALUES (NULL::INTEGER), (0), (1), (3), (4), (7), (8)
) AS test(value);


-- =========================================================
-- Завдання 3. Функція, що повертає таблицю
-- =========================================================

CREATE OR REPLACE FUNCTION books_by_genre(p_genre VARCHAR)
RETURNS TABLE (
    id INTEGER,
    title VARCHAR,
    author VARCHAR,
    publication_year INTEGER,
    genre VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        b.id,
        b.title,
        b.author,
        b.publication_year,
        b.genre
    FROM books b
    WHERE b.genre = p_genre;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM books_by_genre('Роман');

-- Контрольне порівняння з прямим SELECT:
SELECT id, title, author, publication_year, genre
FROM books
WHERE genre = 'Роман';


-- =========================================================
-- Завдання 4. Свідома помилка: COMMIT у функції
-- CREATE FUNCTION проходить, помилка виникає під час SELECT.
-- =========================================================

CREATE OR REPLACE FUNCTION test_commit_function()
RETURNS TEXT AS $$
BEGIN
    COMMIT;
    RETURN 'Транзакцію завершено';
END;
$$ LANGUAGE plpgsql;

-- Цей виклик навмисно завершується помилкою SQLSTATE 2D000:
-- ERROR: неприпустиме завершення транзакції
-- CONTEXT: Функція PL/pgSQL test_commit_function() рядок 3 в COMMIT
-- ПОМИЛКА: неприпустиме завершення транзакції
-- SQL state: 2D000
SELECT test_commit_function();


-- =========================================================
-- Завдання 5. Використання функції у WHERE
-- =========================================================

SELECT
    title,
    copies_count,
    book_stock_category(copies_count) AS category
FROM books
WHERE book_stock_category(copies_count) = 'багато примірників';

-- Альтернативний варіант тієї самої умови через CASE:
SELECT
    title,
    copies_count
FROM books
WHERE
    CASE
        WHEN copies_count IS NULL THEN 'не вказано'
        WHEN copies_count = 0 THEN 'немає в наявності'
        WHEN copies_count <= 3 THEN 'мало примірників'
        WHEN copies_count <= 7 THEN 'достатньо примірників'
        ELSE 'багато примірників'
    END = 'багато примірників';


-- =========================================================
-- Завдання 6. Точний збіг типів у RETURN QUERY
-- Перший варіант навмисно має помилку: COUNT(*) повертає BIGINT,
-- а вихідний стовпець оголошено як INTEGER.
-- =========================================================

CREATE OR REPLACE FUNCTION genre_book_counts()
RETURNS TABLE (
    genre_name VARCHAR,
    total_books INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        b.genre,
        COUNT(*)
    FROM books b
    GROUP BY b.genre;
END;
$$ LANGUAGE plpgsql;

-- Цей виклик навмисно завершується помилкою SQLSTATE 42804.
-- ERROR: structure of query does not match function result type
-- Повернений тип bigint не відповідає очікуваному типу integer в стовпці 2.
-- SQL state: 42804
SELECT * FROM genre_book_counts();


-- Спосіб 1. Явне приведення COUNT(*) до INTEGER:
CREATE OR REPLACE FUNCTION genre_book_counts()
RETURNS TABLE (
    genre_name VARCHAR,
    total_books INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        b.genre,
        COUNT(*)::INTEGER
    FROM books b
    GROUP BY b.genre;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM genre_book_counts();


-- Спосіб 2. Оголошення вихідної кількості як BIGINT.
-- Спочатку видаляємо функцію, бо CREATE OR REPLACE не змінює
-- типи вихідних параметрів RETURNS TABLE.
DROP FUNCTION genre_book_counts();

CREATE FUNCTION genre_book_counts()
RETURNS TABLE (
    genre_name VARCHAR,
    total_books BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        b.genre,
        COUNT(*)
    FROM books b
    GROUP BY b.genre;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM genre_book_counts();


-- Додаткова перевірка фактичних типів колонок таблиці books:
SELECT
    pg_typeof(genre) AS genre_type,
    pg_typeof(title) AS title_type,
    pg_typeof(author) AS author_type,
    pg_typeof(copies_count) AS copies_type
FROM books
LIMIT 1;
