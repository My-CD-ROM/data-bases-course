
PRAGMA foreign_keys = ON;

SELECT
    movies.title AS фільм,
    tickets.hall AS зал,
    tickets.showtime AS час_сеансу,
    tickets.seat AS місце,
    tickets.price AS ціна
FROM tickets
INNER JOIN movies ON tickets.movie_id = movies.id
ORDER BY tickets.showtime;

SELECT
    movies.title AS фільм,
    viewers.first_name || ' ' || viewers.last_name AS глядач,
    tickets.showtime AS час_сеансу,
    tickets.seat AS місце,
    tickets.price AS ціна
FROM tickets
INNER JOIN movies ON tickets.movie_id = movies.id
INNER JOIN viewers ON tickets.viewer_id = viewers.id
ORDER BY tickets.showtime;

SELECT
    movies.title AS фільм,
    movies.genre AS жанр
FROM movies
LEFT JOIN tickets ON movies.id = tickets.movie_id
WHERE tickets.id IS NULL;

SELECT COUNT(*) AS кількість_фільмів FROM movies;

SELECT COUNT(*) AS кількість_глядачів FROM viewers;

SELECT COUNT(*) AS усі_комбінації
FROM movies, viewers;

-- Результати завдання 4:
-- Фільмів: 7
-- Глядачів: 6
-- Усі комбінації: 42
