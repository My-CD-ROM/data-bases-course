PRAGMA foreign_keys = ON;

SELECT
    tickets.id AS ticket_id,
    movies.title AS movie,
    tickets.showtime,
    tickets.price
FROM tickets
INNER JOIN movies ON tickets.movie_id = movies.id
WHERE tickets.price >= 180
ORDER BY tickets.showtime;

SELECT
    movies.title AS movie,
    viewers.last_name || ' ' || viewers.first_name AS viewer,
    tickets.showtime,
    tickets.price
FROM tickets
INNER JOIN movies ON tickets.movie_id = movies.id
INNER JOIN viewers ON tickets.viewer_id = viewers.id
ORDER BY tickets.showtime;

SELECT
    movies.id,
    movies.title AS movie,
    movies.genre,
    movies.year
FROM movies
LEFT JOIN tickets ON tickets.movie_id = movies.id
WHERE tickets.id IS NULL
ORDER BY movies.id;

SELECT COUNT(*) FROM movies, viewers;
-- Результат: 24

SELECT COUNT(*) FROM movies;
-- Результат: 6

SELECT COUNT(*) FROM viewers;