-- Практична робота №10
-- Тема: HAVING
-- Варіант 1: Бібліотека
-- Angelina Masiuk, IT-31

-- Завдання 1
SELECT
    book_id,
    COUNT(*) AS кількість_видач
FROM loans
GROUP BY book_id
HAVING COUNT(*) > 2;

-- Результат: 0 рядків.


-- Завдання 2
SELECT
    book_id,
    MAX(reader_id) AS максимальний_reader_id
FROM loans
GROUP BY book_id
HAVING MAX(reader_id) > 4;

-- Результат: 4 рядки.


-- Завдання 3
SELECT
    book_id,
    COUNT(*) AS кількість_видач
FROM loans
WHERE loan_date >= '2026-09-12'
GROUP BY book_id
HAVING COUNT(*) > 1;

-- Результат: 1 рядок.


-- Завдання 4
-- Навмисна помилка: агрегатна функція COUNT() використана у WHERE.
SELECT
    book_id,
    COUNT(*) AS кількість_видач
FROM loans
WHERE COUNT(*) > 1
GROUP BY book_id;

-- Точний текст помилки SQLite:
-- misuse of aggregate: COUNT()


-- Завдання 5
SELECT
    books.id,
    books.title,
    COUNT(loans.id) AS кількість_видач
FROM books
LEFT JOIN loans
    ON loans.book_id = books.id
GROUP BY books.id
HAVING COUNT(loans.id) < 2;

-- Результат: 3 рядки.