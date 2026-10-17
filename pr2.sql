-- Практична робота №2. SQLite. Варіант 3 - Кінотеатр

SELECT title, genre, release_year, ticket_price
FROM movies;

SELECT title, release_year
FROM movies
WHERE release_year > 2010;

SELECT title, genre
FROM movies
LIMIT 3;

INSERT INTO movies (title, genre, duration, release_year, ticket_price)
VALUES ('Minecraft Movie', NULL, 101, 2025, 250.00);

SELECT title, genre
FROM movies
WHERE genre IS NULL;

SELECT title, genre
FROM movies
WHERE genre IS NOT NULL;

SELECT title, ticket_price, release_year
FROM movies
WHERE ticket_price > 200 AND release_year >= 2014;
