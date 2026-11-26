ALTER TABLE memberships ADD COLUMN weekly_equivalent REAL
    GENERATED ALWAYS AS (ROUND(price * 7.0 / duration_days, 2)) VIRTUAL;
SELECT id, type, duration_days, price, weekly_equivalent
FROM memberships ORDER BY id;

ALTER TABLE memberships ADD COLUMN is_30_day INTEGER
    GENERATED ALWAYS AS (duration_days = 30) VIRTUAL;
SELECT id, type, duration_days, is_30_day
FROM memberships ORDER BY id;

UPDATE memberships SET weekly_equivalent = 1 WHERE id = 8;
SELECT id, price, weekly_equivalent FROM memberships WHERE id = 8;

SELECT id, type, price, weekly_equivalent FROM memberships WHERE id = 8;
UPDATE memberships SET price = 799.0 WHERE id = 8;
SELECT id, type, price, weekly_equivalent FROM memberships WHERE id = 8;
UPDATE memberships SET price = 699.0 WHERE id = 8;

SELECT id, type, weekly_equivalent
FROM memberships
WHERE weekly_equivalent > 200
ORDER BY weekly_equivalent DESC;

PRAGMA integrity_check;
SELECT id, type, duration_days, price, weekly_equivalent, is_30_day
FROM memberships WHERE id = 8;
