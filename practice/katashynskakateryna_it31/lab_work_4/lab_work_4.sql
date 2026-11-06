PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS viewers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT
);

CREATE TABLE IF NOT EXISTS tickets (
    id INTEGER PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    viewer_id INTEGER NOT NULL,
    hall TEXT NOT NULL,
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

INSERT INTO viewers
    (id, last_name, first_name, email, phone)
VALUES
    (1, 'Коваль', 'Анна', 'anna.koval@gmail.com', '+380671112233'),
    (2, 'Шевченко', 'Максим', 'maksym.shevchenko@gmail.com', '+380672223344'),
    (3, 'Мельник', 'Олена', 'olena.melnyk@gmail.com', '+380673334455'),
    (4, 'Бондаренко', 'Андрій', 'andrii.bondarenko@gmail.com', '+380674445566'),
    (5, 'Ткаченко', 'Марія', 'maria.tkachenko@gmail.com', '+380675556677'),
    (6, 'Савченко', 'Дмитро', 'dmytro.savchenko@gmail.com', '+380676667788');


INSERT INTO tickets
    (movie_id, viewer_id, hall, showtime, price, seat, purchase_date)
VALUES
    (1, 1, 'Зал 1', '2026-09-20 18:00', 180.00, 'A1', '2026-09-18'),
    (2, 2, 'Зал 2', '2026-09-20 20:30', 200.00, 'B5', '2026-09-19'),
    (3, 3, 'Зал 1', '2026-09-21 17:00', 170.00, 'C3', '2026-09-19'),
    (4, 4, 'Зал 3', '2026-09-21 19:30', 160.00, 'D7', '2026-09-20'),
    (5, 5, 'Зал 2', '2026-09-22 15:00', 140.00, 'A4', '2026-09-21'),
    (6, 6, 'Зал 3', '2026-09-22 21:00', 190.00, 'C8', '2026-09-21'),
    (1, 2, 'Зал 1', '2026-09-23 18:00', 180.00, 'B2', '2026-09-22'),
    (2, 3, 'Зал 2', '2026-09-23 20:30', 200.00, 'C5', '2026-09-22'),
    (4, 1, 'Зал 3', '2026-09-24 19:30', 160.00, 'A6', '2026-09-22'),
    (6, 5, 'Зал 3', '2026-09-25 21:00', 190.00, 'D4', '2026-09-22');


SELECT * FROM viewers;

SELECT * FROM tickets;

PRAGMA foreign_key_list(tickets);

SELECT name, sql
FROM sqlite_master
WHERE type = 'table'
  AND name IN ('movies', 'viewers', 'tickets');

INSERT INTO tickets
    (movie_id, viewer_id, hall, showtime, price, seat, purchase_date)
VALUES
    (1, 999, 'Зал 1', '2026-09-26 18:00', 180.00, 'E1', '2026-09-22');