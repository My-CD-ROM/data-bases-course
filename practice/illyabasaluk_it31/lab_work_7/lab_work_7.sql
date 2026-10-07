-- Практична робота 7
-- Варіант 1 — Бібліотека
-- Студент: Ілля Басалик
-- Група: IT-31


-- =====================================================
-- Завдання 1. INNER JOIN факт + вимір 1
-- =====================================================

SELECT
    books.title AS книга,
    loans.loan_date AS дата_видачі,
    loans.return_date AS дата_повернення
FROM loans
INNER JOIN books
    ON loans.book_id = books.id
ORDER BY loans.loan_date;


-- =====================================================
-- Завдання 2. INNER JOIN усіх трьох таблиць
-- =====================================================

SELECT
    books.title AS книга,
    readers.first_name AS ім_я,
    readers.last_name AS прізвище,
    loans.loan_date AS дата_видачі
FROM loans
INNER JOIN books
    ON loans.book_id = books.id
INNER JOIN readers
    ON loans.reader_id = readers.id
ORDER BY loans.loan_date;


-- =====================================================
-- Завдання 3. LEFT JOIN — книги без жодної видачі
-- =====================================================

SELECT
    books.id,
    books.title,
    books.author
FROM books
LEFT JOIN loans
    ON loans.book_id = books.id
WHERE loans.id IS NULL;


-- =====================================================
-- Завдання 4. CROSS JOIN
-- =====================================================

-- Кількість книг
SELECT COUNT(*) AS кількість_книг
FROM books;

-- Кількість читачів
SELECT COUNT(*) AS кількість_читачів
FROM readers;

-- Кількість усіх можливих пар книг і читачів
SELECT COUNT(*) AS кількість_пар
FROM books, readers;і