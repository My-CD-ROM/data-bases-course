PRAGMA foreign_keys = ON;

SELECT *
FROM tickets
WHERE id = 1;

UPDATE tickets
SET showtime = '2026-09-20 18:30'
WHERE id = 1;

SELECT *
FROM tickets
WHERE id = 1;

SELECT *
FROM viewers
WHERE id = 1;

UPDATE viewers
SET phone = '+380671234567'
WHERE id = 1;

SELECT *
FROM viewers
WHERE id = 1;

SELECT COUNT(*) AS count_before_delete
FROM tickets;

SELECT *
FROM tickets
WHERE id = 10;

DELETE FROM tickets
WHERE id = 10;

SELECT COUNT(*) AS count_after_delete
FROM tickets;

SELECT *
FROM tickets
WHERE id = 10;

SELECT *
FROM viewers
WHERE id = 6;

SELECT *
FROM tickets
WHERE viewer_id = 6;

SELECT COUNT(*) AS tickets_before_cascade
FROM tickets
WHERE viewer_id = 6;

DELETE FROM viewers
WHERE id = 6;

SELECT *
FROM viewers
WHERE id = 6;

SELECT *
FROM tickets
WHERE viewer_id = 6;

SELECT COUNT(*) AS tickets_after_cascade
FROM tickets
WHERE viewer_id = 6;

SELECT *
FROM viewers;

SELECT *
FROM tickets;

PRAGMA foreign_key_list(tickets);