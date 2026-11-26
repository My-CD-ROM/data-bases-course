
ALTER TABLE books
ADD COLUMN weekly_copy_days INTEGER
GENERATED ALWAYS AS (copies_count * 7) VIRTUAL;

ALTER TABLE books
ADD COLUMN is_modern INTEGER
GENERATED ALWAYS AS (publication_year >= 2000) VIRTUAL;

.headers on
.mode column

SELECT id, title, copies_count, weekly_copy_days
FROM books
WHERE id >= 18
ORDER BY id;

SELECT id, title, publication_year, is_modern
FROM books
WHERE id >= 18
ORDER BY id;

UPDATE books
SET weekly_copy_days = 100
WHERE id = 18;

SELECT id, title, copies_count, weekly_copy_days
FROM books
WHERE id = 18;

UPDATE books
SET copies_count = 6
WHERE id = 18;

SELECT id, title, copies_count, weekly_copy_days
FROM books
WHERE id = 18;

SELECT id, title, copies_count, weekly_copy_days
FROM books
WHERE weekly_copy_days > 20
ORDER BY weekly_copy_days DESC;

UPDATE books
SET copies_count = 5
WHERE id = 18;

SELECT id, title, copies_count, weekly_copy_days
FROM books
WHERE id = 18;
