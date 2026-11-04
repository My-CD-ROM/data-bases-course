SELECT COUNT(*), MAX(id) FROM rooms;
-- Результат: 15, 15

-- Завдання 1: наївний імпорт
CREATE TABLE rooms_staging (type TEXT, price_per_night REAL, capacity INTEGER, status TEXT);
-- .mode csv
-- .import --skip 1 v6_raw_rows.csv rooms_staging
-- v6_raw_rows.csv:2: expected 4 columns but found 1 - filling the rest with NULL
-- v6_raw_rows.csv:3: expected 4 columns but found 1 - filling the rest with NULL
-- v6_raw_rows.csv:4: expected 4 columns but found 1 - filling the rest with NULL
SELECT COUNT(*) FROM rooms_staging;   -- 10
SELECT * FROM rooms_staging LIMIT 1;  -- весь запис в першій колонці
DELETE FROM rooms_staging;

-- Завдання 2: правильний імпорт
-- .separator ";"
-- .import --skip 1 v6_raw_rows.csv rooms_staging
SELECT COUNT(*) FROM rooms_staging;   -- 10

-- Завдання 3: контроль якості
SELECT SUM(type = '') AS type_empty, SUM(price_per_night = '') AS price_empty,
       SUM(capacity = '') AS cap_empty, SUM(status = '') AS status_empty
FROM rooms_staging;
-- 0, 0, 2, 0
SELECT typeof(capacity), COUNT(*) FROM rooms_staging GROUP BY typeof(capacity);
-- integer 8, text 2
SELECT type, price_per_night, capacity, status, COUNT(*) AS cnt
FROM rooms_staging
GROUP BY type, price_per_night, capacity, status
HAVING COUNT(*) > 1;
-- Економ, 850.0, 1, вільний, cnt = 2
-- Розрахунок: 10 - 1 дублікат - 2 неповні = 7

-- Завдання 4: перенесення
-- Пряма спроба з NULLIF:
-- Runtime error: NOT NULL constraint failed: rooms.capacity (19)
INSERT INTO rooms (type, price_per_night, capacity, status)
SELECT DISTINCT type, price_per_night, NULLIF(capacity, ''), NULLIF(status, '')
FROM rooms_staging
WHERE type <> '' AND price_per_night <> '' AND capacity <> '' AND status <> '';
SELECT COUNT(*), MAX(id) FROM rooms;
-- Результат: 22, 22 (приріст 7)
SELECT id, type FROM rooms WHERE capacity IS NULL OR status IS NULL;
-- порожньо: колонки NOT NULL
DROP TABLE rooms_staging;

-- Завдання 5: експорт
-- .headers on
-- .mode csv
-- .output rooms_export.csv
SELECT id, type, price_per_night, capacity, status FROM rooms WHERE id > 15;
-- .output stdout
