-- Завдання 1
SELECT COUNT(*) FROM rooms;
-- Результат: 7

-- Завдання 2
CREATE TABLE rooms_staging (
    type TEXT,
    price_per_night REAL,
    capacity INTEGER,
    status TEXT
);
-- Команди CLI (не SQL):
-- .mode csv
-- .import --skip 1 v6_new_rows.csv rooms_staging
SELECT * FROM rooms_staging;

-- Завдання 3
INSERT INTO rooms (type, price_per_night, capacity, status)
SELECT type, price_per_night, capacity, status FROM rooms_staging;
DROP TABLE rooms_staging;
SELECT COUNT(*) FROM rooms;
-- Результат: 15 (приріст 8)

-- Завдання 4
SELECT id, type, status FROM rooms WHERE type IN ('економ', 'студіо', 'мансарда');
-- Результат: id 8, 9, 15 (продовжують нумерацію 1-7)

-- Завдання 5 (на тестовій копії бази):
-- .mode csv
-- .import --skip 1 v6_new_rows.csv rooms
-- v6_new_rows.csv:2: expected 5 columns but found 4 - filling the rest with NULL
-- v6_new_rows.csv:2: INSERT failed: datatype mismatch
-- (те саме для рядків 3-9)
-- SELECT COUNT(*) FROM rooms;  -- 7, нічого не додалося
