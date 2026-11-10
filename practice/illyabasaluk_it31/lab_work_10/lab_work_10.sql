-- Практична робота 10
-- Відбір груп за допомогою HAVING
-- Варіант 1 — Бібліотека
-- Ілля Басалик, IT-31


-- Завдання 1
-- Групи книг, де кількість позик перевищує 1
SELECT
    book_id,
    COUNT(*) AS кількість_позик
FROM loans
GROUP BY book_id
HAVING COUNT(*) > 1;


-- Завдання 2
-- Книги, середня кількість примірників яких більша за 3
SELECT
    title AS назва_книги,
    AVG(copies_count) AS середня_кількість_примірників
FROM books
GROUP BY id
HAVING AVG(copies_count) > 3;


-- Завдання 3
-- WHERE фільтрує окремі рядки, HAVING — сформовані групи
SELECT
    author,
    COUNT(*) AS кількість_книг
FROM books
WHERE publication_year > 2000
GROUP BY author
HAVING COUNT(*) > 1;


-- Завдання 4
-- ПОМИЛКОВИЙ ЗАПИТ: агрегатну функцію не можна використовувати у WHERE
SELECT
    book_id,
    COUNT(*) AS кількість_позик
FROM loans
WHERE COUNT(*) > 1
GROUP BY book_id;

-- Результат:
-- misuse of aggregate: COUNT()


-- Завдання 5
-- LEFT JOIN дозволяє врахувати книги без жодної позики
SELECT
    books.title AS назва_книги,
    COUNT(loans.id) AS кількість_позик
FROM books
LEFT JOIN loans
    ON loans.book_id = books.id
GROUP BY books.id
HAVING COUNT(loans.id) < 2;