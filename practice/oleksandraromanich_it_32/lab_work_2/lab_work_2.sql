SELECT title, author, publication_year, copies_count
FROM books;

SELECT title, author, publication_year, copies_count
FROM books
WHERE publication_year > 2000;

SELECT title, author, genre
FROM books
LIMIT 5;

INSERT INTO books (title, author, publication_year, genre, copies_count)
VALUES ('Невідомий рукопис', 'Анонім', NULL, NULL, 2);

SELECT title, genre
FROM books
WHERE genre IS NULL;

SELECT title, genre
FROM books
WHERE genre IS NOT NULL;

SELECT title, author, publication_year, genre, copies_count
FROM books
WHERE genre = 'детектив' AND publication_year > 2000;