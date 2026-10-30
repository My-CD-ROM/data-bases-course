CREATE TABLE reservations (
    id             INTEGER PRIMARY KEY,
    book_id        INTEGER NOT NULL,
    reader_id      INTEGER NOT NULL,
    reserved_date  TEXT NOT NULL,
    status         TEXT NOT NULL DEFAULT 'активне'
                   CHECK (status IN ('активне', 'скасоване', 'виконане')),
    FOREIGN KEY (book_id)   REFERENCES books(id)   ON DELETE CASCADE,
    FOREIGN KEY (reader_id) REFERENCES readers(id) ON DELETE CASCADE
);

INSERT INTO reservations (book_id, reader_id, reserved_date, status) VALUES
    (1,  1, '2025-03-01', 'активне'),
    (1,  3, '2025-03-02', 'активне'),
    (1,  4, '2025-03-03', 'активне'),
    (2,  2, '2025-03-05', 'активне'),
    (2,  5, '2025-03-06', 'активне'),
    (5,  2, '2025-03-10', 'активне'),
    (5,  3, '2025-03-11', 'активне'),
    (5,  4, '2025-03-12', 'активне'),
    (5,  5, '2025-03-13', 'активне'),
    (6,  1, '2025-03-15', 'активне'),
    (7,  2, '2025-03-16', 'скасоване'),
    (6,  3, '2025-03-17', 'виконане');
	
SELECT books.id, books.title, COUNT(reservations.id) AS reservations_count
FROM books
JOIN reservations ON reservations.book_id = books.id
GROUP BY books.id;

SELECT books.id, books.title, COUNT(reservations.id) AS reservations_count
FROM books
JOIN reservations ON reservations.book_id = books.id
GROUP BY books.id
HAVING COUNT(reservations.id) >= 3;

SELECT books.id, books.title, COUNT(reservations.id) AS active_count
FROM books
JOIN reservations ON reservations.book_id = books.id
WHERE reservations.status = 'активне'
GROUP BY books.id
HAVING COUNT(reservations.id) >= 3;

INSERT INTO books (title, author, publication_year, genre, copies_count)
VALUES ('Кобзар', 'Інший автор', 1900, 'поезія', 1);

INSERT INTO reservations (book_id, reader_id, reserved_date, status) VALUES
    (24, 1, '2025-03-20', 'активне'),
    (24, 2, '2025-03-21', 'активне');
	
SELECT id, title, author FROM books WHERE title = 'Кобзар';

SELECT books.title, COUNT(reservations.id) AS reservations_count
FROM books
JOIN reservations ON reservations.book_id = books.id
GROUP BY books.title;

SELECT books.id, books.title, COUNT(reservations.id) AS active_count
FROM books
LEFT JOIN reservations ON reservations.book_id = books.id
WHERE reservations.status = 'активне'
GROUP BY books.id
HAVING COUNT(reservations.id) >= 3;

