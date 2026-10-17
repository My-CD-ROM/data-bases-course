-- Практична робота 8
-- Тема: Застосування агрегатних функцій
-- Варіант 1: Бібліотека
-- Angelina Masiuk, IT-31

-- Завдання 1. COUNT та робота з NULL
SELECT
    COUNT(*) AS всього_видач,
    COUNT(return_date) AS повернення_заповнені,
    COUNT(*) - COUNT(return_date) AS без_дати_повернення
FROM loans;
-- Результат: 10 | 6 | 4

-- Завдання 2. SUM та AVG
SELECT
    SUM(copies_count) AS загальна_кількість_примірників,
    AVG(copies_count) AS середня_кількість_примірників
FROM books;
-- Результат: 27 | 3.85714285714286 (≈ 3.86)

-- Завдання 3. MIN та MAX
SELECT
    MIN(loan_date) AS найраніша_дата_видачі,
    MAX(loan_date) AS найпізніша_дата_видачі
FROM loans;
-- Результат: 2026-09-10 | 2026-09-17

-- Завдання 4. Комбінація агрегатних функцій
SELECT
    COUNT(*) AS всього_видач,
    COUNT(return_date) AS повернені,
    MIN(loan_date) AS перша_видача,
    MAX(loan_date) AS остання_видача
FROM loans;
-- Результат: 10 | 6 | 2026-09-10 | 2026-09-17

-- Завдання 5. Агрегатні функції з WHERE на таблицю-вимір books
SELECT
    COUNT(*) AS всього_видач,
    COUNT(loans.return_date) AS повернення_заповнені,
    MIN(loans.loan_date) AS найраніша_видача,
    MAX(loans.loan_date) AS найпізніша_видача
FROM loans
INNER JOIN books
    ON loans.book_id = books.id
WHERE books.genre = 'роман';
-- Результат: 4 | 3 | 2026-09-10 | 2026-09-16
