-- Практична робота №4
-- Варіант №1 — Бібліотека

PRAGMA foreign_keys = ON;

-- Таблиця-вимір 1
CREATE TABLE books (
    id INTEGER PRIMARY KEY,
    title TEXT,
    author TEXT,
    publication_year INTEGER,
    genre TEXT,
    copies_count INTEGER
);

INSERT INTO books (title, author, publication_year, genre, copies_count) VALUES
('Кобзар', 'Тарас Шевченко', 1840, 'Поезія', 5),
('Тигролови', 'Іван Багряний', 1944, 'Роман', 3),
('Місто', 'Валерʼян Підмогильний', 1928, 'Роман', 4),
('Захар Беркут', 'Іван Франко', 1883, 'Історичний роман', 6),
('Лісова пісня', 'Леся Українка', 1911, 'Драма', 4),
('Чорна рада', 'Пантелеймон Куліш', 1857, 'Історичний роман', 2),
('Нова книга', 'Невідомий автор', 2020, NULL, 1);

-- Таблиця-вимір 2
CREATE TABLE readers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT NOT NULL,
    registration_date TEXT NOT NULL
);

INSERT INTO readers (last_name, first_name, email, registration_date) VALUES
('Шевченко', 'Олена', 'olena@gmail.com', '2026-09-01'),
('Коваленко', 'Максим', 'maksym@gmail.com', '2026-09-02'),
('Бондаренко', 'Анна', 'anna@gmail.com', '2026-09-03'),
('Мельник', 'Андрій', 'andrii@gmail.com', '2026-09-04'),
('Ткаченко', 'Софія', 'sofia@gmail.com', '2026-09-05'),
('Іваненко', 'Дмитро', 'dmytro@gmail.com', '2026-09-06');

-- Фактова таблиця
CREATE TABLE loans (
    id INTEGER PRIMARY KEY,
    book_id INTEGER NOT NULL,
    reader_id INTEGER NOT NULL,
    loan_date TEXT NOT NULL,
    return_date TEXT,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE RESTRICT,
    FOREIGN KEY (reader_id) REFERENCES readers(id) ON DELETE RESTRICT
);

INSERT INTO loans (book_id, reader_id, loan_date, return_date) VALUES
(1, 1, '2026-09-10', '2026-09-17'),
(2, 2, '2026-09-11', '2026-09-18'),
(3, 3, '2026-09-12', '2026-09-19'),
(4, 1, '2026-09-13', '2026-09-20'),
(5, 4, '2026-09-14', NULL),
(6, 5, '2026-09-15', '2026-09-22'),
(1, 6, '2026-09-16', NULL),
(2, 1, '2026-09-17', NULL),
(3, 2, '2026-09-18', '2026-09-23'),
(4, 3, '2026-09-19', NULL);