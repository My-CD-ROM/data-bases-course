.schema books

CREATE TABLE books_staging (
    title TEXT,
    author TEXT,
    publication_year INTEGER,
    genre TEXT,
    copies_count INTEGER
);

.mode csv
.import --skip 1 "Практична 17/v1_raw_rows.csv" books_staging

SELECT COUNT(*) FROM books_staging;
SELECT * FROM books_staging LIMIT 1;

DELETE FROM books_staging;

.mode csv
.separator ";"
.import --skip 1 "Практична 17/v1_raw_rows.csv" books_staging

SELECT COUNT(*) FROM books_staging;

SELECT
    SUM(title IS NULL OR TRIM(title) = '') AS empty_title,
    SUM(author IS NULL OR TRIM(author) = '') AS empty_author,
    SUM(TRIM(CAST(publication_year AS TEXT)) = '') AS empty_year,
    SUM(genre IS NULL OR TRIM(genre) = '') AS empty_genre,
    SUM(TRIM(CAST(copies_count AS TEXT)) = '') AS empty_copies
FROM books_staging;

SELECT title, author, COUNT(*) AS duplicate_count
FROM books_staging
GROUP BY title, author
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS books_before, MAX(id) AS max_id_before
FROM books;

INSERT INTO books (title, author, publication_year, genre, copies_count)
SELECT DISTINCT
    TRIM(title),
    TRIM(author),
    NULLIF(TRIM(CAST(publication_year AS TEXT)), ''),
    NULLIF(TRIM(genre), ''),
    NULLIF(TRIM(CAST(copies_count AS TEXT)), '')
FROM books_staging
WHERE TRIM(title) <> ''
  AND TRIM(author) <> '';

SELECT COUNT(*) AS books_after, MAX(id) AS max_id_after
FROM books;

SELECT id, title, author, publication_year, genre, copies_count
FROM books
WHERE id > 17;

DROP TABLE books_staging;

.headers on
.mode csv
.output "Практична 17/books_export.csv"
SELECT * FROM books WHERE id > 17;
.output stdout