CREATE TABLE books (
    id                INTEGER PRIMARY KEY,
    title             TEXT NOT NULL,
    author            TEXT NOT NULL,
    publication_year  INTEGER,
    genre             TEXT,
    copies_count      INTEGER
);

CREATE TABLE readers (
    id                 INTEGER PRIMARY KEY,
    last_name          TEXT NOT NULL,
    first_name         TEXT NOT NULL,
    email              TEXT,
    registration_date  TEXT
);

CREATE TABLE loans (
    id           INTEGER PRIMARY KEY,
    book_id      INTEGER NOT NULL,
    reader_id    INTEGER NOT NULL,
    loan_date    TEXT,
    return_date  TEXT,
    FOREIGN KEY (book_id)   REFERENCES books(id),
    FOREIGN KEY (reader_id) REFERENCES readers(id)
);

INSERT INTO books (title, author, publication_year, genre, copies_count) VALUES
    ('Кобзар', 'Тарас Шевченко', 1840, 'поезія', 12),
    ('Місто', 'Валер''ян Підмогильний', 1928, 'роман', 7),
    ('Тіні забутих предків', 'Михайло Коцюбинський', 1911, 'повість', 5),
    ('1984', 'Джордж Орвелл', 1949, 'антиутопія', 15),
    ('Гаррі Поттер і філософський камінь', 'Джоан Роулінг', 1997, 'фентезі', 20);

INSERT INTO readers (last_name, first_name, email, registration_date) VALUES
    ('Шевченко', 'Олена', 'olena@example.com', '2024-09-01'),
    ('Коваленко', 'Ігор', 'ihor@example.com', '2024-09-15'),
    ('Бондаренко', 'Марія', 'maria@example.com', '2024-10-03'),
    ('Ткаченко', 'Андрій', 'andrii@example.com', '2024-11-12'),
    ('Мельник', 'Наталія', 'nataliia@example.com', '2025-01-08');

INSERT INTO loans (book_id, reader_id, loan_date, return_date) VALUES
    (1, 1, '2025-01-10', '2025-01-20'),
    (2, 2, '2025-01-12', '2025-01-25'),
    (4, 1, '2025-01-15', NULL),
    (1, 3, '2025-01-17', '2025-01-28'),
    (5, 4, '2025-01-19', NULL),
    (3, 5, '2025-01-20', '2025-02-01'),
    (2, 2, '2025-01-22', NULL);

SELECT loans.id, readers.last_name, books.title, loans.loan_date, loans.return_date
FROM loans
JOIN readers ON readers.id = loans.reader_id
JOIN books   ON books.id   = loans.book_id;