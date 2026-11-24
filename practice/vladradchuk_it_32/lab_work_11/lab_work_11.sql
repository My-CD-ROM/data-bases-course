
-- Практична робота №11

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS watchlist (
    id INTEGER PRIMARY KEY,
    movie_id INTEGER NOT NULL,
    viewer_id INTEGER NOT NULL,
    added_date TEXT NOT NULL,
    priority INTEGER NOT NULL CHECK (priority BETWEEN 1 AND 5),
    status TEXT NOT NULL DEFAULT 'заплановано',
    UNIQUE(movie_id, viewer_id),
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (viewer_id) REFERENCES viewers(id)
);

INSERT OR IGNORE INTO watchlist
(movie_id, viewer_id, added_date, priority)
VALUES
(1, 1, '2026-11-01', 5),
(1, 2, '2026-11-02', 4),
(1, 3, '2026-11-03', 3),
(2, 1, '2026-11-04', 4),
(2, 4, '2026-11-05', 5),
(3, 2, '2026-11-06', 5),
(3, 3, '2026-11-07', 4),
(5, 5, '2026-11-08', 3);

SELECT
    movies.title,
    viewers.first_name,
    viewers.last_name,
    watchlist.added_date,
    watchlist.priority
FROM watchlist
INNER JOIN movies ON watchlist.movie_id = movies.id
INNER JOIN viewers ON watchlist.viewer_id = viewers.id;

SELECT
    movies.id,
    movies.title,
    COUNT(watchlist.viewer_id) AS viewers_count
FROM movies
INNER JOIN watchlist ON movies.id = watchlist.movie_id
GROUP BY movies.id, movies.title;

SELECT
    movies.id,
    movies.title,
    COUNT(watchlist.viewer_id) AS viewers_count
FROM movies
INNER JOIN watchlist ON movies.id = watchlist.movie_id
GROUP BY movies.id, movies.title
HAVING COUNT(watchlist.viewer_id) > 1;

SELECT
    viewers.id,
    viewers.first_name,
    viewers.last_name,
    COUNT(watchlist.movie_id) AS movies_count
FROM viewers
INNER JOIN watchlist ON viewers.id = watchlist.viewer_id
GROUP BY viewers.id;


SELECT
    viewers.id,
    viewers.first_name,
    viewers.last_name,
    COUNT(watchlist.movie_id) AS movies_count
FROM viewers
INNER JOIN watchlist ON viewers.id = watchlist.viewer_id
GROUP BY viewers.id
HAVING COUNT(watchlist.movie_id) > 1;


SELECT
    movies.id,
    movies.title,
    COUNT(watchlist.viewer_id) AS viewers_count
FROM movies
LEFT JOIN watchlist ON movies.id = watchlist.movie_id
GROUP BY movies.id, movies.title;


SELECT
    viewers.first_name,
    viewers.last_name,
    COUNT(watchlist.movie_id) AS movies_count
FROM viewers
INNER JOIN watchlist ON viewers.id = watchlist.viewer_id
GROUP BY viewers.first_name, viewers.last_name;


SELECT
    movies.id,
    movies.title,
    COUNT(watchlist.viewer_id) AS viewers_count
FROM movies
LEFT JOIN watchlist ON movies.id = watchlist.movie_id
WHERE watchlist.added_date >= '2026-11-04'
GROUP BY movies.id, movies.title
HAVING COUNT(watchlist.viewer_id) > 1;


SELECT COUNT(*) AS watchlist_count
FROM watchlist;
