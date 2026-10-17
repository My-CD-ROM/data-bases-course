-- Практична робота 7
-- Вовк Марія Віталіївна
-- Група І-23


-- ==========================================
-- Завдання 1
-- INNER JOIN факт + вимір 1
-- ==========================================

SELECT 
    books.title AS "Назва книги",
    loans.loan_date AS "Дата видачі"
FROM loans
INNER JOIN books ON loans.book_id = books.id
ORDER BY loans.loan_date;


-- ==========================================
-- Завдання 2
-- INNER JOIN усіх трьох таблиць
-- ==========================================

SELECT 
    books.title AS "Назва книги",
    readers.name AS "Ім'я читача",
    loans.loan_date AS "Дата видачі"
FROM loans
INNER JOIN books ON loans.book_id = books.id
INNER JOIN readers ON loans.reader_id = readers.id
ORDER BY loans.loan_date;


-- ==========================================
-- Завдання 3
-- LEFT JOIN: книги без жодної видачі
-- ==========================================

SELECT 
    books.id AS "ID книги",
    books.title AS "Назва книги"
FROM books
LEFT JOIN loans ON loans.book_id = books.id
WHERE loans.id IS NULL;


-- ==========================================
-- Завдання 4
-- CROSS JOIN
-- ==========================================

SELECT COUNT(*) AS "Кількість пар books x readers"
FROM books, readers;

SELECT COUNT(*) AS "Кількість книг"
FROM books;

SELECT COUNT(*) AS "Кількість читачів"
FROM readers;