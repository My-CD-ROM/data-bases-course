
PRAGMA foreign_keys = ON;

-- Завдання 1. Підрахунок до імпорту

SELECT COUNT(*) AS total_before
FROM memberships;


-- Завдання 2. Створення проміжної таблиці

CREATE TABLE memberships_staging (
    type TEXT,
    duration_days INTEGER,
    price REAL
);

-- Перевірка проміжної таблиці
-- Після імпорту CSV виконай:
-- SELECT * FROM memberships_staging;


-- Завдання 3. Перенесення даних у memberships

INSERT INTO memberships (type, duration_days, price)
SELECT type, duration_days, price
FROM memberships_staging;

-- Видалення проміжної таблиці

DROP TABLE memberships_staging;

-- Підрахунок після імпорту

SELECT COUNT(*) AS total_after
FROM memberships;


-- Завдання 4. Перевірка нових записів

SELECT id, type, duration_days, price
FROM memberships
ORDER BY id;


-- Завдання 5. Перевірка індексів і таблиць
-- Для практики 16 перевіряємо наявність staging після видалення

SELECT name
FROM sqlite_master
WHERE type = 'table'
ORDER BY name;