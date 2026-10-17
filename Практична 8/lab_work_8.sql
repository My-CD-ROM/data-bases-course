@"
-- Практична робота 8
-- Виконала: Вовк Марія Віталіївна
-- Група: І-23

PRAGMA foreign_keys = ON;

-- Завдання 1
SELECT
    COUNT(*) AS all_loans,
    COUNT(return_date) AS loans_with_return_date
FROM loans;

SELECT COUNT(*) - COUNT(return_date) AS loans_with_null_return_date
FROM loans;

-- Завдання 2
SELECT
    SUM(copies_count) AS total_copies,
    AVG(copies_count) AS average_copies
FROM books;

-- Завдання 3
SELECT
    MIN(loan_date) AS earliest_loan_date,
    MAX(loan_date) AS latest_loan_date
FROM loans;

-- Завдання 4
SELECT
    COUNT(*) AS total_loans,
    COUNT(return_date) AS returned_loans,
    MIN(loan_date) AS first_loan_date,
    MAX(loan_date) AS last_loan_date
FROM loans;

-- Завдання 5
SELECT
    COUNT(*) AS novel_loans,
    COUNT(loans.return_date) AS novel_returned_loans
FROM loans
JOIN books ON books.id = loans.book_id
WHERE books.genre LIKE '%роман%';

-- Контрольне питання 3
CREATE TEMP TABLE test_null_values (value INTEGER);

INSERT INTO test_null_values (value)
VALUES (NULL), (NULL), (NULL);

SELECT SUM(value) AS sum_of_all_nulls
FROM test_null_values;

DROP TABLE test_null_values;
"@ | Set-Content "lab_work_8.sql" -Encoding UTF8