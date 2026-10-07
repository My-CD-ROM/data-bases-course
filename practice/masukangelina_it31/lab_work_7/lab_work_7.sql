-- Практична робота №7
-- Варіант 1. Бібліотека

-- Завдання 1. INNER JOIN
SELECT
    books.title AS книга,
    loans.loan_date AS дата_видачі
FROM loans
INNER JOIN books
    ON loans.book_id = books.id
ORDER BY loans.loan_date;


-- Завдання 2. INNER JOIN трьох таблиць
SELECT
    books.title AS книга,
    readers.last_name || ' ' || readers.first_name AS читач,
    loans.loan_date AS дата_видачі
FROM loans
INNER JOIN books
    ON loans.book_id = books.id
INNER JOIN readers
    ON loans.reader_id = readers.id
ORDER BY loans.loan_date;


-- Завдання 3. LEFT JOIN
SELECT
    books.title AS книга
FROM books
LEFT JOIN loans
    ON loans.book_id = books.id
WHERE loans.id IS NULL;


-- Завдання 4. Декартовий добуток
SELECT COUNT(*) AS кількість_книг
FROM books;

SELECT COUNT(*) AS кількість_читачів
FROM readers;

SELECT COUNT(*) AS кількість_комбінацій
FROM books, readers;


-- Завдання 5. INNER JOIN трьох таблиць
SELECT
    books.title AS книга,
    readers.last_name || ' ' || readers.first_name AS читач,
    loans.loan_date AS дата_видачі,
    loans.return_date AS дата_повернення
FROM loans
INNER JOIN books
    ON loans.book_id = books.id
INNER JOIN readers
    ON loans.reader_id = readers.id
ORDER BY loans.loan_date;