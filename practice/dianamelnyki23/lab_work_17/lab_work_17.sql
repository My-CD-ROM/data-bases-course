.bail off
.headers on
.mode column
PRAGMA foreign_keys = ON;

SELECT COUNT(*) AS memberships_before FROM memberships;
CREATE TABLE memberships_staging (
    type TEXT,
    duration_days INTEGER,
    price REAL
);

.mode csv
.import --skip 1 v7_raw_rows.csv memberships_staging
-- v7_raw_rows.csv:2: expected 3 columns but found 1 - filling the rest with NULL
-- v7_raw_rows.csv:3: expected 3 columns but found 2 - filling the rest with NULL
-- v7_raw_rows.csv:4: expected 3 columns but found 1 - filling the rest with NULL
.mode column
SELECT COUNT(*) AS naive_staging_count FROM memberships_staging;
SELECT type, duration_days, price FROM memberships_staging LIMIT 1;
DELETE FROM memberships_staging;

.mode csv
.separator ";"
.import --skip 1 v7_raw_rows.csv memberships_staging
.mode column
SELECT COUNT(*) AS staging_count FROM memberships_staging;
SELECT * FROM memberships_staging;

SELECT SUM(type = '') AS empty_type,
       SUM(duration_days = '') AS empty_duration,
       SUM(price = '') AS empty_price
FROM memberships_staging;
SELECT typeof(duration_days) AS value_type, COUNT(*) AS row_count
FROM memberships_staging GROUP BY typeof(duration_days);
SELECT typeof(price) AS value_type, COUNT(*) AS row_count
FROM memberships_staging GROUP BY typeof(price);
SELECT type, duration_days, price, COUNT(*) AS duplicate_count
FROM memberships_staging
GROUP BY type, duration_days, price
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS memberships_before_transfer, MAX(id) AS max_id_before
FROM memberships;
INSERT INTO memberships (type, duration_days, price)
SELECT DISTINCT type, duration_days, NULLIF(price, '')
FROM memberships_staging
WHERE type <> ''
  AND duration_days <> ''
  AND NULLIF(price, '') IS NOT NULL;
DROP TABLE memberships_staging;
SELECT COUNT(*) AS memberships_after, COUNT(*) - 15 AS imported_count
FROM memberships;
SELECT id, type, duration_days, price
FROM memberships WHERE id > 15 ORDER BY id;
SELECT id, type, duration_days, price
FROM memberships WHERE id > 15 AND price IS NULL;

.headers on
.mode csv
.output memberships_added.csv
SELECT id, type, duration_days, price
FROM memberships WHERE id > 15 ORDER BY id;
.output stdout
.mode column
SELECT COUNT(*) AS exported_rows FROM memberships WHERE id > 15;

SELECT COUNT(*) AS final_memberships FROM memberships;
