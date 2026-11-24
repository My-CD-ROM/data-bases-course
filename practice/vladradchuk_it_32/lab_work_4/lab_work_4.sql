PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS viewers;
DROP TABLE IF EXISTS movies;

CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    genre TEXT NOT NULL,
    duration_min INTEGER NOT NULL,
    year INTEGER NOT NULL,
    age_rating INTEGER NOT NULL
);

INSERT INTO movies (id, title, genre, duration_min, year, age_rating) VALUES
(1, 'Тіні забутих предків', 'драма', 97, 1965, 12),
(2, 'Захар Беркут', 'бойовик', 115, 2019, 16),
(3, 'Мавка. Лісова пісня', 'анімація', 94, 2023, 6),
(4, 'Я, Ти, Він, Вона', 'комедія', 90, 2021, 16),
(5, 'Атлантида', 'драма', 108, 2019, 16),
(6, 'Памфір', 'драма', 106, 2022, 18);

CREATE TABLE viewers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT,
    phone TEXT
);

INSERT INTO viewers (id, last_name, first_name, email, phone) VALUES
(1, 'Шевченко', 'Андрій', 'andriy@gmail.com', '+380501112233'),
(2, 'Коваленко', 'Олена', 'olena@gmail.com', '+380671234567'),
(3, 'Бондаренко', 'Максим', 'maksym@gmail.com', '+380931234567'),
(4, 'Мельник', 'Ірина', 'iryna@gmail.com', '+380991112233'),
(5, 'Ткаченко', 'Дмитро', 'dmytro@gmail.com', '+380631234567'),
(6, 'Кравченко', 'Марія', 'maria@gmail.com', '+380501234567');

CREATE TABLE tickets (
    id INTEGER PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    viewer_id INTEGER NOT NULL,
    hall INTEGER NOT NULL,
    showtime TEXT NOT NULL,
    price REAL NOT NULL,
    seat TEXT NOT NULL,
    purchase_date TEXT NOT NULL,
    FOREIGN KEY (movie_id)
        REFERENCES movies(id)
        ON DELETE RESTRICT,
    FOREIGN KEY (viewer_id)
        REFERENCES viewers(id)
        ON DELETE CASCADE
);

INSERT INTO tickets (movie_id, viewer_id, hall, showtime, price, seat, purchase_date) VALUES
(1, 1, 1, '2026-11-20 15:00', 150.00, 'A1', '2026-11-19'),
(2, 2, 1, '2026-11-20 18:00', 180.00, 'A2', '2026-11-19'),
(3, 3, 2, '2026-11-20 16:00', 160.00, 'B1', '2026-11-20'),
(4, 4, 2, '2026-11-21 17:00', 150.00, 'B2', '2026-11-20'),
(5, 5, 1, '2026-11-21 19:00', 170.00, 'C1', '2026-11-20'),
(6, 6, 1, '2026-11-21 20:00', 190.00, 'C2', '2026-11-20'),
(1, 2, 2, '2026-11-22 15:00', 150.00, 'D1', '2026-11-21'),
(3, 4, 2, '2026-11-22 16:00', 160.00, 'D2', '2026-11-21'),
(5, 1, 1, '2026-11-23 19:00', 170.00, 'E1', '2026-11-22'),
(2, 3, 1, '2026-11-23 18:00', 180.00, 'E2', '2026-11-22');