-- Практична робота №15
-- Створення індексів та аналіз ефективності запитів
-- Виконала: Вовк Марія, група І-23

-- Завдання 1. Перевірка плану до створення індексу
EXPLAIN QUERY PLAN
SELECT * FROM loans WHERE book_id = 1;

-- Результат:
-- QUERY PLAN
-- `--SCAN loans


-- Завдання 2. Створення індексу за book_id
CREATE INDEX idx_loans_book_id ON loans(book_id);

EXPLAIN QUERY PLAN
SELECT * FROM loans WHERE book_id = 1;

-- Результат:
-- QUERY PLAN
-- `--SEARCH loans USING INDEX idx_loans_book_id (book_id=?)


-- Завдання 3. Композитний індекс
EXPLAIN QUERY PLAN
SELECT * FROM loans WHERE book_id = 1 AND reader_id = 1;

-- Результат до композитного індексу:
-- QUERY PLAN
-- `--SEARCH loans USING INDEX idx_loans_book_id (book_id=?)

CREATE INDEX idx_loans_book_reader ON loans(book_id, reader_id);

EXPLAIN QUERY PLAN
SELECT * FROM loans WHERE book_id = 1 AND reader_id = 1;

-- Результат після створення:
-- QUERY PLAN
-- `--SEARCH loans USING INDEX idx_loans_book_reader (book_id=? AND reader_id=?)


-- Завдання 4. Індекс за датою
EXPLAIN QUERY PLAN
SELECT * FROM loans ORDER BY loan_date;

-- Результат до індексу:
-- QUERY PLAN
-- |--SCAN loans
-- `--USE TEMP B-TREE FOR ORDER BY

CREATE INDEX idx_loans_loan_date ON loans(loan_date);

EXPLAIN QUERY PLAN
SELECT * FROM loans ORDER BY loan_date;

-- Результат після створення:
-- QUERY PLAN
-- `--SCAN loans USING INDEX idx_loans_loan_date


-- Завдання 5. Видалення одноколонкового індексу
DROP INDEX idx_loans_book_id;

EXPLAIN QUERY PLAN
SELECT * FROM loans WHERE book_id = 1;

-- Результат після видалення:
-- QUERY PLAN
-- `--SEARCH loans USING INDEX idx_loans_book_reader (book_id=?)

-- Перевірка індексів, які залишилися
SELECT name
FROM sqlite_master
WHERE type = 'index' AND tbl_name = 'loans';

-- Залишилися:
-- idx_loans_book_reader
-- idx_loans_loan_date