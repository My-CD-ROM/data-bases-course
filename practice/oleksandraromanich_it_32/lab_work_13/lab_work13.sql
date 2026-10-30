SELECT id, title, printf('%d прим.', copies_count) AS copies_formatted
FROM books
LIMIT 5;

SELECT id, title, printf('%8d прим.', copies_count) AS aligned_copies
FROM books
LIMIT 5;

SELECT id, loan_date, date(loan_date, '+14 days') AS due_date
FROM loans;

SELECT strftime('%Y', loan_date) AS yr, COUNT(*) AS loans_count
FROM loans
GROUP BY yr
ORDER BY yr;

SELECT strftime('%Y', 'not-a-date') AS result_year;

SELECT strftime('%Y-%m', loan_date) AS month, COUNT(*) AS loans_count
FROM loans
GROUP BY month
ORDER BY month;
