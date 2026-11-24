PRAGMA foreign_keys = ON;

UPDATE tickets
SET showtime = '2026-11-20 16:00'
WHERE id = 1;

UPDATE movies
SET status = 'архівний'
WHERE id = 6;

SELECT COUNT(*) FROM tickets;

DELETE FROM tickets
WHERE id = 10;

SELECT COUNT(*) FROM tickets;

SELECT * FROM tickets WHERE id = 10;

SELECT * FROM tickets WHERE viewer_id = 1;

SELECT COUNT(*) FROM tickets;

DELETE FROM viewers
WHERE id = 1;

SELECT * FROM tickets WHERE viewer_id = 1;

SELECT COUNT(*) FROM tickets;

UPDATE movies
SET duration_min = -10
WHERE id = 1;

SELECT id, title, duration_min
FROM movies
WHERE id = 1;