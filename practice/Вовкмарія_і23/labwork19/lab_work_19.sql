
-- Практична робота 19
-- Міграція бази даних SQLite до PostgreSQL
-- Автор: Вовк Марія, група І-23

-- 1. Створення таблиці books
CREATE TABLE books (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(150) NOT NULL,
    publication_year INTEGER,
    genre VARCHAR(100),
    copies_count INTEGER DEFAULT 1 CHECK (copies_count >= 0),
    weekly_copy_days INTEGER,
    is_modern BOOLEAN,
    UNIQUE (title, author)
);

-- 2. Створення таблиці readers
CREATE TABLE readers (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    address TEXT
);

-- 3. Створення таблиці loans
CREATE TABLE loans (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    book_id INTEGER NOT NULL
        REFERENCES books(id) ON DELETE RESTRICT,
    reader_id INTEGER NOT NULL
        REFERENCES readers(id) ON DELETE CASCADE,
    loan_date DATE NOT NULL,
    return_date DATE
);

-- 4. Імпорт даних із CSV
-- Імпорт виконувався через команду psql \copy:
-- books: 26 записів
-- readers: 5 записів
-- loans: 9 записів

-- 5. Додавання технічного запису читача
-- У початковій базі одна позика посилалася на відсутнього читача ID 1.
INSERT INTO readers (id, name, phone, address)
OVERRIDING SYSTEM VALUE
VALUES (1, 'Unknown reader', 'Not specified', NULL);

-- 6. Перевірка кількості записів
SELECT 'books' AS table_name, COUNT(*) FROM books
UNION ALL
SELECT 'readers', COUNT(*) FROM readers
UNION ALL
SELECT 'loans', COUNT(*) FROM loans;

-- 7. Налаштування послідовностей ID
SELECT setval(
    pg_get_serial_sequence('books', 'id'),
    (SELECT MAX(id) FROM books)
);

SELECT setval(
    pg_get_serial_sequence('readers', 'id'),
    (SELECT MAX(id) FROM readers)
);

SELECT setval(
    pg_get_serial_sequence('loans', 'id'),
    (SELECT MAX(id) FROM loans)
);

-- 8. Перевірка автоматичної нумерації
INSERT INTO books (title, author, publication_year, genre, copies_count)
VALUES ('Test Book', 'Test Author', 2026, 'Test', 1);

SELECT id, title, author
FROM books
WHERE title = 'Test Book';

-- Видалення тестового запису
DELETE FROM books WHERE title = 'Test Book';

-- 9. Перевірка зовнішнього ключа
-- Очікувана помилка: книга з ID 99999 не існує.
-- INSERT INTO loans (book_id, reader_id, loan_date)
-- VALUES (99999, 1, CURRENT_DATE);

-- 10. Перевірка структури таблиць
-- Виконати в psql:
-- \d books
-- \d readers
-- \d loans
