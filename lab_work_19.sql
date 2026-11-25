CREATE DATABASE cinema_db;

CREATE TABLE movies (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(100) NOT NULL,
    duration_min INTEGER NOT NULL,
    year INTEGER NOT NULL,
    age_rating INTEGER NOT NULL
);

CREATE TABLE viewers (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(30) NOT NULL
);

CREATE TABLE tickets (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    viewer_id INTEGER NOT NULL,
    hall INTEGER NOT NULL,
    showtime TIMESTAMP NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    seat VARCHAR(20) NOT NULL,
    purchase_date DATE NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE RESTRICT,
    FOREIGN KEY (viewer_id) REFERENCES viewers(id) ON DELETE CASCADE
);

-- Імпорт CSV виконувався через \copy у psql:
-- movies.csv: 21 запис
-- viewers.csv: 4 записи
-- tickets.csv: 7 записів

-- Синхронізація лічильників IDENTITY
SELECT setval(pg_get_serial_sequence('movies', 'id'), COALESCE(MAX(id), 1)) FROM movies;
SELECT setval(pg_get_serial_sequence('viewers', 'id'), COALESCE(MAX(id), 1)) FROM viewers;
SELECT setval(pg_get_serial_sequence('tickets', 'id'), COALESCE(MAX(id), 1)) FROM tickets;

-- Перевірка кількості записів
SELECT 'movies' AS table_name, COUNT(*) AS records FROM movies
UNION ALL
SELECT 'viewers', COUNT(*) FROM viewers
UNION ALL
SELECT 'tickets', COUNT(*) FROM tickets;

-- Перевірка зовнішнього ключа:
-- Спроба додати квиток з неіснуючим movie_id = 9999
-- очікувано завершується помилкою зовнішнього ключа.
