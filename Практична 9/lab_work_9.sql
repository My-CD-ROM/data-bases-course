-- Практична робота 9. Формування запитів з групуванням даних
-- Виконав: Вовк Марія
-- Група: І-23

-- Завдання 1
SELECT reader_id, COUNT(*) AS loans_count
FROM loans
GROUP BY reader_id;


-- Завдання 2
SELECT readers.name, COUNT(loans.id) AS loans_count
FROM readers
LEFT JOIN loans ON loans.reader_id = readers.id
GROUP BY readers.id;


-- Завдання 3
SELECT reader_id,
       COUNT(*) AS loans_count,
       MIN(id) AS first_loan_id
FROM loans
GROUP BY reader_id;


-- Завдання 4
SELECT reader_id, book_id, COUNT(*) AS loans_count
FROM loans
GROUP BY reader_id, book_id;


-- Додатково: кількість унікальних читачів
SELECT COUNT(DISTINCT reader_id) AS unique_readers
FROM loans;


-- Додатково: кількість унікальних книг
SELECT COUNT(DISTINCT book_id) AS unique_books
FROM loans;


-- Завдання 5
-- book_id навмисно не входить до GROUP BY
SELECT reader_id, book_id, COUNT(*) AS loans_count
FROM loans
GROUP BY reader_id;