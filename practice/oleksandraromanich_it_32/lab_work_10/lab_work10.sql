SELECT book_id, COUNT(*) AS loans_count
FROM loans
GROUP BY book_id
HAVING COUNT(*) >= 2;

SELECT reader_id,
       MAX(julianday(return_date) - julianday(loan_date)) AS max_loan_days
FROM loans
WHERE return_date IS NOT NULL
GROUP BY reader_id
HAVING MAX(julianday(return_date) - julianday(loan_date)) > 10;

SELECT book_id,
       COUNT(*) AS loans_count,
       MIN(loan_date) AS first_loan,
       MAX(loan_date) AS last_loan
FROM loans
WHERE loan_date >= '2025-01-15'
GROUP BY book_id
HAVING COUNT(*) >= 2;

SELECT book_id, COUNT(*) AS loans_count
FROM loans
WHERE COUNT(*) > 1
GROUP BY book_id;

SELECT books.id, books.title, COUNT(loans.id) AS loans_count
FROM books
LEFT JOIN loans ON loans.book_id = books.id
GROUP BY books.id
HAVING COUNT(loans.id) < 2;
