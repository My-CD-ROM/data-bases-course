-- Практична робота №7
-- Варіант: Кінотеатр
-- INNER JOIN, LEFT JOIN та CROSS JOIN

-- Створення таблиць
CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    genre TEXT NOT NULL,
    duration_min INTEGER NOT NULL,
    year INTEGER NOT NULL
);

CREATE TABLE halls (
    id INTEGER PRIMARY KEY,
    hall_number INTEGER NOT NULL UNIQUE,
    seats INTEGER NOT NULL
);

CREATE TABLE sessions (
    id INTEGER PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    hall_id INTEGER NOT NULL,
    session_date TEXT NOT NULL,
    session_time TEXT NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (hall_id) REFERENCES halls(id)
);

-- =========================================================
-- Завдання 1. INNER JOIN факт + вимір 1
-- =========================================================

SELECT movies.title AS фільм, sessions.session_date AS дата, sessions.session_time AS час
FROM sessions
INNER JOIN movies ON sessions.movie_id = movies.id
ORDER BY sessions.session_date, sessions.session_time;

-- Результат:
-- Інтерстеллар | 2026-10-07 | 18:30
-- Аватар       | 2026-10-07 | 20:00
-- Дюна         | 2026-10-08 | 17:00
-- Інтерстеллар | 2026-10-08 | 21:00

-- =========================================================
-- Завдання 2. INNER JOIN усіх трьох таблиць
-- =========================================================

SELECT movies.title AS фільм, halls.hall_number AS зал,
       sessions.session_date AS дата, sessions.session_time AS час
FROM sessions
INNER JOIN movies ON sessions.movie_id = movies.id
INNER JOIN halls ON sessions.hall_id = halls.id
ORDER BY sessions.session_date, sessions.session_time;

-- Результат:
-- Інтерстеллар | 2 | 2026-10-07 | 18:30
-- Аватар       | 1 | 2026-10-07 | 20:00
-- Дюна         | 3 | 2026-10-08 | 17:00
-- Інтерстеллар | 1 | 2026-10-08 | 21:00

-- =========================================================
-- Завдання 3. LEFT JOIN — фільми без жодного сеансу
-- =========================================================

SELECT movies.title AS фільм
FROM movies
LEFT JOIN sessions ON sessions.movie_id = movies.id
WHERE sessions.id IS NULL
ORDER BY movies.title;

-- Результат:
-- Матриця
-- Шрек

-- =========================================================
-- Завдання 4. Свідома пастка CROSS JOIN
-- =========================================================

SELECT COUNT(*) AS кількість_фільмів FROM movies;
-- Результат: 5

SELECT COUNT(*) AS кількість_залів FROM halls;
-- Результат: 3

SELECT COUNT(*) AS кількість_комбінацій
FROM movies, halls;

-- Результат: 15
-- Це добуток 5 * 3, а не сума.
-- Без умови з'єднання кожен фільм поєднується з кожним залом.
