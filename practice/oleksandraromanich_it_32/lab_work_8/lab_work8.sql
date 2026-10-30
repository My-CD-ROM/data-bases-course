PRAGMA table_info(loans);

PRAGMA table_info(readers);

SELECT COUNT(*) FROM loans;

SELECT COUNT(return_date) FROM loans;

SELECT COUNT(*) AS total_loans,
       COUNT(return_date) AS returned,
       COUNT(*) - COUNT(return_date) AS not_returned
FROM loans;

SELECT id, return_date FROM loans ORDER BY return_date LIMIT 5;

UPDATE loans SET return_date = NULL WHERE id = 1;

SELECT COUNT(*) AS total_after,
       COUNT(return_date) AS returned_after,
       COUNT(*) - COUNT(return_date) AS not_returned_after
FROM loans;

SELECT id, return_date FROM loans WHERE id = 1;

SELECT SUM(copies_count) AS total_copies,
       AVG(copies_count) AS avg_copies,
       COUNT(copies_count) AS denom
FROM books;

SELECT MIN(publication_year) AS oldest_year,
       MAX(publication_year) AS newest_year
FROM books;

SELECT MIN(title) AS first_title,
       MAX(title) AS last_title
FROM books;

SELECT MIN(loan_date) AS first_loan,
       MAX(loan_date) AS last_loan
FROM loans;

SELECT COUNT(*)              AS total_loans,
       COUNT(return_date)    AS returned,
       COUNT(*) - COUNT(return_date) AS not_returned,
       MIN(loan_date)        AS first_loan,
       MAX(loan_date)        AS last_loan
FROM loans;


SELECT MIN(publication_year) AS oldest,
       MAX(publication_year) AS newest,
       AVG(publication_year) AS avg_year,
       COUNT(*)              AS total_books
FROM books;

SELECT COUNT(*)            AS total_loans,
       COUNT(return_date)  AS returned
FROM loans;

SELECT COUNT(*)            AS fantasy_loans,
       COUNT(return_date)  AS fantasy_returned
FROM loans l
JOIN books b ON b.id = l.book_id
WHERE b.genre = 'фентезі';

SELECT b.genre,
       COUNT(*)           AS loans_count,
       COUNT(l.return_date) AS returned_count
FROM loans l
JOIN books b ON b.id = l.book_id
GROUP BY b.genre;

SELECT COUNT(*) FROM loans;
SELECT COUNT(return_date) FROM loans;
SELECT COUNT(*) AS total_loans,
       COUNT(return_date) AS returned,
       COUNT(*) - COUNT(return_date) AS not_returned
FROM loans;

SELECT SUM(copies_count) AS total_copies,
       AVG(copies_count) AS avg_copies,
       COUNT(copies_count) AS denom
FROM books;


