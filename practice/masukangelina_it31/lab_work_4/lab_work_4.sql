-- Практична робота №4
-- Варіант 1: Бібліотека

PRAGMA foreign_keys = ON;

-- Таблиця книг
CREATE TABLE books (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    publication_year INTEGER NOT NULL,
    genre TEXT,
    copies_count INTEGER NOT NULL
);

INSERT INTO books (id, title, author, publication_year, genre, copies_count)
VALUES
(1, 'Кобзар', 'Тарас Шевченко', 1840, 'поезія', 5),
(2, 'Тигролови', 'Іван Багряний', 1944, 'роман', 4),
(3, 'Місто', 'Валер’ян Підмогильний', 1928, 'роман', 3),
(4, 'Лісова пісня', 'Леся Українка', 1911, 'драма', 6),
(5, 'Захар Беркут', 'Іван Франко', 1883, 'історична повість', 4),
(6, '1984', 'Джордж Орвелл', 1949, 'антиутопія', 3);

-- Таблиця читачів
CREATE TABLE readers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT NOT NULL,
    registration_date TEXT NOT NULL
);

INSERT INTO readers (id, last_name, first_name, email, registration_date)
VALUES
(1, 'Шевченко', 'Олена', 'olena@example.com', '2026-09-01'),
(2, 'Коваленко', 'Андрій', 'andriy@example.com', '2026-09-02'),
(3, 'Мельник', 'Марія', 'maria@example.com', '2026-09-03'),
(4, 'Бондар', 'Олександр', 'oleksandr@example.com', '2026-09-04'),
(5, 'Ткаченко', 'Ірина', 'iryna@example.com', '2026-09-05'),
(6, 'Романюк', 'Дмитро', 'dmytro@example.com', '2026-09-06');

-- Таблиця видачі книг
CREATE TABLE loans (
    id INTEGER PRIMARY KEY,
    book_id INTEGER NOT NULL,
    reader_id INTEGER,
    loan_date TEXT NOT NULL,
    return_date TEXT,
    FOREIGN KEY (book_id)
        REFERENCES books(id)
        ON DELETE RESTRICT,
    FOREIGN KEY (reader_id)
        REFERENCES readers(id)
        ON DELETE SET NULL
);

INSERT INTO loans (id, book_id, reader_id, loan_date, return_date)
VALUES
(1, 1, 1, '2026-09-10', '2026-09-17'),
(2, 2, 2, '2026-09-10', '2026-09-18'),
(3, 3, 3, '2026-09-11', '2026-09-19'),
(4, 4, 4, '2026-09-12', NULL),
(5, 5, 5, '2026-09-12', '2026-09-20'),
(6, 6, 6, '2026-09-13', NULL),
(7, 1, 2, '2026-09-14', '2026-09-21'),
(8, 3, 4, '2026-09-15', NULL),
(9, 2, 5, '2026-09-16', '2026-09-22'),
(10, 4, 6, '2026-09-17', NULL);

-- Перевірка зовнішніх ключів
PRAGMA foreign_key_list(loans);