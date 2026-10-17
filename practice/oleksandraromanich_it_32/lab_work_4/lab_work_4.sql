PRAGMA foreign_keys = ON;

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
    FOREIGN KEY (book_id)   REFERENCES books (id)   ON DELETE RESTRICT,
    FOREIGN KEY (reader_id) REFERENCES readers (id) ON DELETE CASCADE
);

INSERT INTO readers (last_name, first_name, email, registration_date) VALUES
    ('Шевченко',   'Олена',    'olena.shevchenko@library.ua',  '2024-09-01'),
    ('Коваленко',  'Ігор',     'ihor.kovalenko@library.ua',    '2024-09-15'),
    ('Бондаренко', 'Марія',    'maria.bondarenko@library.ua',  '2024-10-03'),
    ('Ткаченко',   'Андрій',   'andrii.tkachenko@library.ua',  '2024-11-12'),
    ('Мельник',    'Наталія',  'nataliia.melnyk@library.ua',   '2025-01-08'),
    ('Гриценко',   'Павло',    'pavlo.hrytsenko@library.ua',   '2025-02-14');

INSERT INTO loans (book_id, reader_id, loan_date, return_date) VALUES
    (1,  1, '2025-01-10', '2025-01-20'),
    (2,  2, '2025-01-12', '2025-01-25'),
    (4,  1, '2025-01-15', NULL),
    (1,  3, '2025-01-17', '2025-01-28'),
    (5,  4, '2025-01-19', NULL),
    (3,  5, '2025-01-20', '2025-02-01'),
    (2,  2, '2025-01-22', NULL),
    (6,  1, '2025-01-25', '2025-02-05'),
    (7,  3, '2025-01-27', NULL),
    (8,  6, '2025-01-29', '2025-02-10');