SELECT book_id, COUNT(*) AS loans_count
FROM loans
GROUP BY book_id;

SELECT reader_id, COUNT(*) AS loans_count
FROM loans
GROUP BY reader_id;

SELECT b.id, b.title, COUNT(l.id) AS loans_count
FROM books b
LEFT JOIN loans l ON l.book_id = b.id
GROUP BY b.id;

SELECT r.id, r.last_name, r.first_name, COUNT(l.id) AS loans_count
FROM readers r
LEFT JOIN loans l ON l.reader_id = r.id
GROUP BY r.id;

SELECT b.id,
       b.title,
       COUNT(l.id)   AS loans_count,
       MIN(l.loan_date) AS first_loan,
       MAX(l.loan_date) AS last_loan
FROM books b
LEFT JOIN loans l ON l.book_id = b.id
GROUP BY b.id;

SELECT r.id,
       r.last_name,
       COUNT(l.id) AS loans_count,
       MIN(l.loan_date) AS first_loan,
       MAX(l.loan_date) AS last_loan
FROM readers r
LEFT JOIN loans l ON l.reader_id = r.id
GROUP BY r.id;

SELECT b.genre,
       COUNT(l.id) AS loans_count,
       COUNT(DISTINCT l.book_id) AS distinct_books
FROM loans l
JOIN books b ON b.id = l.book_id
GROUP BY b.genre;

SELECT genre, COUNT(*) AS books_count FROM books GROUP BY genre;

SELECT strftime('%Y-%m', loan_date) AS month, COUNT(*) AS loans_count
FROM loans
GROUP BY strftime('%Y-%m', loan_date);

SELECT l.book_id,
       b.title,
       COUNT(*) AS loans_count
FROM loans l
JOIN books b ON b.id = l.book_id
GROUP BY l.book_id;

SELECT l.book_id,
       b.title,
       b.genre,
       COUNT(*) AS loans_count
FROM loans l
JOIN books b ON b.id = l.book_id
GROUP BY l.book_id;

