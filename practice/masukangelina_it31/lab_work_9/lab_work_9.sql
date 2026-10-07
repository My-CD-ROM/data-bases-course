-- Практична робота №9
-- Тема: GROUP BY
-- Варіант 1: Бібліотека
-- Angelina Masiuk, IT-31

-- Завдання 1
SELECT
    book_id,
    COUNT(*) AS кількість_видач
FROM loans
GROUP BY book_id;

-- Результат: 6 рядків.


-- Завдання 2
SELECT
    books.id,
    books.title,
    COUNT(loans.id) AS кількість_видач
FROM books
LEFT JOIN loans
    ON loans.book_id = books.id
GROUP BY books.id;

-- Результат: 7 рядків.


-- Завдання 3
SELECT
    books.id,
    books.title,
    COUNT(loans.id) AS кількість_видач,
    AVG(loans.book_id) AS середній_book_id
FROM books
LEFT JOIN loans
    ON loans.book_id = books.id
GROUP BY books.id;

-- Результат: 7 рядків.


-- Завдання 4
SELECT
    book_id,
    reader_id,
    COUNT(*) AS кількість_видач
FROM loans
GROUP BY book_id, reader_id;

-- Результат: 10 рядків.


-- Завдання 5
SELECT
    book_id,
    reader_id,
    COUNT(*) AS кількість_видач
FROM loans
GROUP BY book_id;

-- Результат: 6 рядків.
-- Запит виконано двічі без помилки в SQLite.