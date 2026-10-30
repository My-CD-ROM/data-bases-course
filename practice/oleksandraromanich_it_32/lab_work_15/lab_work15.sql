EXPLAIN QUERY PLAN
SELECT * FROM loans WHERE book_id = 1;

CREATE INDEX idx_loans_reader_book ON loans(reader_id, book_id);

EXPLAIN QUERY PLAN
SELECT * FROM loans WHERE book_id = 1;

EXPLAIN QUERY PLAN
SELECT * FROM loans WHERE reader_id = 2 AND book_id = 1;

CREATE INDEX idx_loans_reader_book ON loans(reader_id, book_id);

EXPLAIN QUERY PLAN
SELECT * FROM loans WHERE reader_id = 2 AND book_id = 1;

EXPLAIN QUERY PLAN
SELECT * FROM loans ORDER BY loan_date;

CREATE INDEX idx_loans_date ON loans(loan_date);

EXPLAIN QUERY PLAN
SELECT * FROM loans ORDER BY loan_date;

DROP INDEX idx_loans_book;

EXPLAIN QUERY PLAN
SELECT * FROM loans WHERE book_id = 1;

SELECT name FROM sqlite_master WHERE type='index' AND tbl_name='loans';