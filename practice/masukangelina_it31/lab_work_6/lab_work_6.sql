-- Практична робота №6
-- UPDATE та DELETE
-- Варіант 1: Бібліотека


-- Завдання 1. UPDATE у фактовій таблиці

UPDATE loans
SET return_date = '2026-09-23'
WHERE id = 4;


-- Завдання 2. UPDATE у таблиці-вимірі

UPDATE books
SET copies_count = 6
WHERE id = 1;


-- Завдання 3. DELETE одного рядка

SELECT COUNT(*) AS loans_before
FROM loans;

DELETE FROM loans
WHERE id = 2;

SELECT COUNT(*) AS loans_after
FROM loans;


-- Завдання 4. Перевірка ON DELETE SET NULL

PRAGMA foreign_keys = ON;

DELETE FROM readers
WHERE id = 4;

SELECT id, book_id, reader_id, loan_date, return_date
FROM loans
WHERE id IN (4, 8);