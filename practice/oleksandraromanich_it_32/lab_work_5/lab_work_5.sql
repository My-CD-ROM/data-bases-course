PRAGMA foreign_keys = OFF;

CREATE TABLE books_new (
    id                INTEGER PRIMARY KEY,
    title             TEXT NOT NULL,
    author            TEXT NOT NULL,
    publication_year  INTEGER CHECK (publication_year >= 1000 AND publication_year <= 2100),
    genre             TEXT,
    copies_count      INTEGER NOT NULL DEFAULT 1,
    UNIQUE (title, author)
);

INSERT INTO books_new SELECT * FROM books;
DROP TABLE books;
ALTER TABLE books_new RENAME TO books;

PRAGMA foreign_keys = ON;

SELECT sql FROM sqlite_master WHERE name='books';

INSERT INTO books (title, author, publication_year, genre, copies_count)
VALUES ('Тест-C', 'Тест', 900, 'жанр', 1);

INSERT INTO readers (last_name, first_name, email, registration_date)
VALUES ('Тест-U', 'Тест', 'olena.shevchenko@library.ua', '2025-03-01');

INSERT INTO books (title, author, publication_year, genre)
VALUES ('Тест-D', 'Тест', 2020, 'жанр');

SELECT id, title, copies_count FROM books WHERE title = 'Тест-D';

INSERT INTO loans (book_id, reader_id, return_date)
VALUES (1, 1, '2025-12-31');
