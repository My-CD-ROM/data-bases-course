PRAGMA foreign_keys = ON;
UPDATE loans SET return_date = '2025-02-12' WHERE id = 3;
SELECT id, book_id, reader_id, loan_date, return_date FROM loans WHERE id = 3;

UPDATE books SET copies_count = copies_count + 3 WHERE id = 5;
SELECT id, title, copies_count FROM books WHERE id = 5;

SELECT COUNT(*) FROM loans;
DELETE FROM loans WHERE id = 7;
SELECT COUNT(*) FROM loans;

DELETE FROM books WHERE id = 1;

