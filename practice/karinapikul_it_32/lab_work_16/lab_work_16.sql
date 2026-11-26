-- ПРАКТИЧНА РОБОТА №16

-- ЗАВДАННЯ 1. Перевірка початкової кількості

SELECT COUNT(*) FROM memberships;

-- Результат:
-- 6

-- ЗАВДАННЯ 2. Створення проміжної таблиці

CREATE TABLE memberships_staging (
    type TEXT,
    duration_days INTEGER,
    price REAL
);


-- ЗАВДАННЯ 3. Імпорт CSV та перевірка

.mode csv

.import --skip 1 /Users/admin/Documents/karinapikul_it_32/docs/practice/csv/14-csv-import/v7_new_rows.csv memberships_staging

SELECT COUNT(*) FROM memberships_staging;

-- Результат:
-- 8

-- ЗАВДАННЯ 4. Перенесення даних

INSERT INTO memberships (type, duration_days, price)
SELECT type, duration_days, price
FROM memberships_staging;

SELECT COUNT(*) FROM memberships;

-- Результат:
-- 14

DROP TABLE memberships_staging;

-- Перевірка:
.tables

-- Результат:
-- memberships

-- ЗАВДАННЯ 5. Перевірка прямого імпорту

.import --skip 1 /Users/admin/Documents/karinapikul_it_32/docs/practice/csv/14-csv-import/v7_new_rows.csv memberships

-- Отримані повідомлення SQLite:
-- expected 4 columns but found 3 - filling the rest with NULL
-- INSERT failed: datatype mismatch
-- Error on line 2
-- Error on line 3
-- Error on line 4
-- Error on line 5
-- Error on line 6
-- Error on line 7
-- Error on line 8
-- Error on line 9

SELECT COUNT(*) FROM memberships;

-- Результат:
-- 14