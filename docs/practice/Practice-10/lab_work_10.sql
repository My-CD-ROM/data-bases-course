PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS readers;

DROP TABLE IF EXISTS books_old;

ALTER TABLE books RENAME TO books_old;

CREATE TABLE books (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT,
    genre TEXT UNIQUE,
    publication_year INTEGER CHECK ( publication_year <= 2026 ),
    copies_count INTEGER NOT NULL DEFAULT 1
--     loans_id INTEGER NOT NULL,
--     readers_id INTEGER,
--     FOREIGN KEY (loans_id) REFERENCES loans (id)
--     FOREIGN KEY (readers_id) REFERENCES readers (id)
);

-- SELECT loans.loan_date AS 'Дата видачі', books.title AS 'Назва книги'
-- FROM loans
-- INNER JOIN books ON loans.book_id = books.id
-- WHERE loans.loan_date BETWEEN '2024-02-01' AND '2024-02-28'
-- ORDER BY loans.loan_date DESC;
--
-- SELECT books.title AS 'Назва книги', readers.last_name AS 'Прізвище читача', loans.loan_date AS 'Дата видачі'
-- FROM loans
-- INNER JOIN books ON loans.book_id = books.id
-- INNER JOIN readers ON loans.reader_id = readers.id
-- WHERE loans.loan_date BETWEEN '2024-02-01' AND '2024-02-28'
-- ORDER BY loans.loan_date DESC, readers.last_name ASC;
--
-- SELECT books.title AS 'Книга, яку ні разу не брали'
-- FROM books
-- LEFT JOIN loans ON books.id = loans.book_id
-- WHERE loans.id IS NULL;
--
-- SELECT COUNT(*) FROM books, readers;
--
-- SELECT COUNT(*) FROM books;
-- SELECT COUNT(*) FROM readers;

-- CREATE TABLE IF NOT EXISTS books (
--     id INTEGER PRIMARY KEY,
--     title TEXT,
--     author TEXT,
--     genre TEXT,
--     publication_year INTEGER,
--     copies_count INTEGER
-- );

-- --Test NOT NULL
-- INSERT INTO books (author, genre, publication_year, copies_count)
-- VALUES ('Тест', 'Поезія', 2026, 1);
--
-- --Test UNIQUE
-- INSERT INTO books (title, author, genre, publication_year, copies_count)
-- VALUES ('Тест', 'Тест', 'Поезія', 2026, 1);
--
-- INSERT INTO books (title, author, genre, publication_year, copies_count)
-- VALUES ('Тест 2', 'Тест', 'Поезія', 2026, 1);
--
-- --Test CHECK (виконана умова)
-- INSERT INTO books (title, author, publication_year, copies_count)
-- VALUES ('Тест 3', 'Тест', 2026, 1);
--
-- --Test CHECK (помилка)
-- INSERT INTO books (title, author, publication_year, copies_count)
-- VALUES ('Тест 3', 'Тест', 2030, 1);
--
-- --Test NOT NULL DEFAULT
-- INSERT INTO books (title, author, publication_year)
-- VALUES ('Тест 4', 'Тест', 2026);
--
-- SELECT title, copies_count FROM books WHERE title = 'Тест 4' AND copies_count = 1;
--
-- --Test UPDATE
-- UPDATE books SET publication_year = 2030 WHERE title = 'Тест 4';
-- --[19] [SQLITE_CONSTRAINT_CHECK] A CHECK constraint failed (CHECK constraint failed: publication_year == 2026)
-- -- Правило CHECK перевіряє дані завжди — і коли створити запис (INSERT), і коли змінити його (UPDATE). Якщо дані неправильні, база даних їх заблокує

INSERT INTO books (title, author, genre, publication_year, copies_count) VALUES
('Кобзар', 'Тарас Шевченко', 'Поезія', 1840, 5),
('Тигролови', 'Іван Багряний', 'Пригодницький роман', 1944, 3),
('Intermezzo', 'Михайло Коцюбинський', 'Новела', 1908, 2),
('Місто', 'Валер''ян Підмогильний', 'Урбаністичний роман', 1928, 4),
('Захар Беркут', 'Іван Франко', 'Історична повість', 1883, 6),
('Тіні забутих предків', 'Михайло Коцюбинський', 'Повість', 1911, 3);

CREATE TABLE readers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT,
    registration_date TEXT
);

CREATE TABLE loans (
    id INTEGER PRIMARY KEY,
    book_id INTEGER NOT NULL,
    reader_id INTEGER,
    loan_date TEXT NOT NULL,
    return_date TEXT,
    FOREIGN KEY (book_id) REFERENCES books (id) ON DELETE RESTRICT,
    FOREIGN KEY (reader_id) REFERENCES readers (id) ON DELETE SET NULL
);

--Task1
SELECT reader_id, COUNT(*) AS loans_count
FROM loans
GROUP BY reader_id
HAVING COUNT(*) > 1;

--Task2
SELECT reader_id, MAX(loan_date) AS last_loan_date
FROM loans
GROUP BY reader_id
HAVING MAX(loan_date) > '2024-03-01';

--Task3
SELECT reader_id, COUNT(*) AS unreturned_loans
FROM loans
WHERE return_date IS NULL
GROUP BY reader_id
HAVING COUNT(*) > 1;

--Task4
SELECT book_id, COUNT(*) AS loans_count
FROM loans
WHERE COUNT(*) > 1
GROUP BY book_id;

--Task5
SELECT books.id, books.title, COUNT(loans.id) AS loans_count
FROM books
LEFT JOIN loans ON books.id = loans.book_id
GROUP BY books.id, books.title
HAVING COUNT(loans.id) < 2;

-- --Task1 and Task3
-- SELECT book_id, COUNT(*) AS loans_count, SUM(id) AS sum_loans_ids
-- FROM loans
-- GROUP BY book_id;
--
-- --Task2
-- SELECT books.title, COUNT(*) AS loans_count
-- FROM loans
-- LEFT JOIN books ON loans.book_id = books.id
-- GROUP BY books.id;
--
-- --Task4
-- SELECT loans.loan_date, loans.return_date, COUNT(*) AS loans_count
-- FROM loans
-- GROUP BY loan_date, return_date;
--
-- --Task5
-- SELECT book_id, reader_id, COUNT(*) AS loans_count
-- FROM loans
-- GROUP BY book_id;

-- UPDATE loans SET return_date = '2026-09-29' WHERE id = 1;
--
-- UPDATE loans SET return_date = '2026-09-29' WHERE id = 3;
-- -- UPDATE, оскільки потрібно змінити лише значення існуючого запису, зберігши його ідентифікатор та всі інші дані
--
-- SELECT COUNT(*) FROM loans;
-- DELETE FROM loans WHERE id = 4;
--
-- SELECT COUNT(*) FROM loans;
--
-- SELECT * FROM books WHERE id = 1;
-- -- Оскільки для зовнішнього ключа стовпця book_id встановлено правило ON DELETE RESTRICT, спроба видалити книгу з id = 1 завершиться помилкою. База даних заблокує видалення, щоб не залишити в таблиці loans «сирітські» записи, які посилаються на неіснуючу книгу
-- DELETE FROM books WHERE id = 1;
-- SELECT * FROM books WHERE id = 1;

INSERT INTO readers (last_name, first_name, email, registration_date) VALUES
('Іваненко', 'Олена', 'olena.ivanenko@example.com', '2023-02-10'),
('Петренко', 'Максим', 'maksym.petrenko@example.com', '2023-03-15'),
('Коваль', 'Дарина', 'daryna.koval@example.com', '2023-05-01'),
('Бондаренко', 'Артем', 'artem.bondarenko@example.com', '2023-06-20'),
('Мельник', 'Софія', 'sofiia.melnyk@example.com', '2024-01-11'),
('Шевчук', 'Богдан', 'bohdan.shevchuk@example.com', '2024-04-07');

INSERT INTO loans (book_id, reader_id, loan_date, return_date) VALUES
(1, 1, '2024-02-01', '2024-02-15'),
(2, 2, '2024-02-03', '2024-02-20'),
(3, 3, '2024-02-05', NULL),
(4, 1, '2024-02-10', '2024-03-01'),
(5, 4, '2024-02-12', NULL),
(6, 5, '2024-02-14', '2024-03-05'),
(1, 6, '2024-03-01', NULL),
(2, 3, '2024-03-02', '2024-03-18'),
(5, 2, '2024-03-05', '2024-03-20'),
(6, 4, '2024-03-10', NULL);

-- SELECT name FROM sqlite_master WHERE type='table';

-- PRAGMA table_info(books);
-- PRAGMA table_info(readers);
-- PRAGMA table_info(loans);
--
-- SELECT * FROM books;
-- SELECT * FROM readers;
-- SELECT * FROM loans;
--
-- SELECT COUNT(*) FROM loans;
-- SELECT COUNT(loans.return_date) FROM loans;
--
-- UPDATE loans SET return_date = NULL WHERE id = 1;
-- SELECT COUNT(*) AS total_rows_after, COUNT(return_date) AS non_null_rows_after
-- FROM loans;
--
-- SELECT SUM(books.copies_count) FROM books;
-- SELECT AVG(books.copies_count) FROM books;
--
-- SELECT MIN(books.title) FROM books;
-- SELECT MAX(books.title) FROM books;
--
-- SELECT
--     COUNT(*) AS total_unique_titles,
--     MIN(copies_count) AS min_copies,
--     MAX(copies_count) AS max_copies,
--     AVG(copies_count) AS avg_copies
-- FROM books;
--
-- SELECT
--     COUNT(*) AS filtered_titles_count,
--     MIN(copies_count) AS filtered_min_copies,
--     MAX(copies_count) AS filtered_max_copies
-- FROM books
-- WHERE copies_count > 2;
