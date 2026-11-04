--Task1
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS books (
    id INTEGER PRIMARY KEY,
    title TEXT,
    author TEXT,
    genre TEXT,
    publication_year INTEGER,
    copies_count INTEGER
);

INSERT INTO books (title, author, genre, publication_year, copies_count) VALUES
('Кобзар', 'Тарас Шевченко', 'Поезія', 1840, 5),
('Тигролови', 'Іван Багряний', 'Пригодницький роман', 1944, 3),
('Intermezzo', 'Михайло Коцюбинський', 'Новела', 1908, 2),
('Місто', 'Валер''ян Підмогильний', 'Урбаністичний роман', 1928, 4),
('Захар Беркут', 'Іван Франко', 'Історична повість', 1883, 6),
('Тіні забутих предків', 'Михайло Коцюбинський', 'Повість', 1911, 3);

CREATE TABLE readers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT,
    registration_date TEXT
);

--Task2

CREATE TABLE loans (
    id INTEGER PRIMARY KEY,
    book_id INTEGER NOT NULL,
    reader_id INTEGER,
    loan_date TEXT NOT NULL,
    return_date TEXT,
    FOREIGN KEY (book_id) REFERENCES books (id) ON DELETE RESTRICT,
    FOREIGN KEY (reader_id) REFERENCES readers (id) ON DELETE SET NULL
);

--Task3

INSERT INTO readers (last_name, first_name, email, registration_date) VALUES
('Іваненко', 'Олена', 'olena.ivanenko@example.com', '2023-02-10'),
('Петренко', 'Максим', 'maksym.petrenko@example.com', '2023-03-15'),
('Коваль', 'Дарина', 'daryna.koval@example.com', '2023-05-01'),
('Бондаренко', 'Артем', 'artem.bondarenko@example.com', '2023-06-20'),
('Мельник', 'Софія', 'sofiia.melnyk@example.com', '2024-01-11'),
('Шевчук', 'Богдан', 'bohdan.shevchuk@example.com', '2024-04-07');

INSERT INTO loans (book_id, reader_id, loan_date, return_date) VALUES
(1, 1, '2024-02-01', '2024-02-15'),
(2, 2, '2024-02-03', '2024-02-20'),
(3, 3, '2024-02-05', NULL),
(4, 1, '2024-02-10', '2024-03-01'),
(5, 4, '2024-02-12', NULL),
(6, 5, '2024-02-14', '2024-03-05'),
(1, 6, '2024-03-01', NULL),
(2, 3, '2024-03-02', '2024-03-18'),
(5, 2, '2024-03-05', '2024-03-20'),
(6, 4, '2024-03-10', NULL);

--Task4

--INSERT INTO loans (book_id, reader_id, loan_date, return_date)
--VALUES (9999, 1, '2024-04-01', NULL);

SELECT name FROM sqlite_master WHERE type='table';

PRAGMA table_info(books);
PRAGMA table_info(readers);
PRAGMA table_info(loans);

SELECT * FROM books;
SELECT * FROM readers;
SELECT * FROM loans;


