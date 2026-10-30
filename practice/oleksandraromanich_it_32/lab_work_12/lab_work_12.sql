SELECT id, book_id, reader_id, loan_date, return_date
FROM loans
ORDER BY loan_date DESC;

SELECT id, book_id, reader_id, reserved_date, status
FROM reservations
ORDER BY status ASC, reserved_date ASC;

SELECT id, book_id, reader_id, reserved_date, status
FROM reservations
ORDER BY reserved_date DESC
LIMIT 3;

SELECT DISTINCT genre
FROM books
ORDER BY genre;

SELECT id, title, publication_year
FROM books
WHERE publication_year BETWEEN 1990 AND 2020
ORDER BY publication_year;

SELECT id, title, author
FROM books
WHERE author LIKE 'Тарас%';

SELECT id, title, author
FROM books
WHERE author LIKE 'тарас%';

SELECT id, title, author
FROM books
WHERE author LIKE 'Тарас%';

