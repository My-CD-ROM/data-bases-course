-- Практична робота №16
-- Імпорт CSV-файлу до SQLite (варіант 3: кінотеатр)
--
-- Запускати у SQLite Command-Line Shell на копії lab_work_15.db.
-- Перед запуском перевірте та за потреби змініть шлях до CSV-файлу.

-- 1. Кількість записів до імпорту
SELECT COUNT(*) AS movies_before FROM movies;

-- 2. Створення проміжної таблиці.
-- age_rating задано як TEXT, оскільки у CSV значення мають вигляд 16+, 12+, 18+.
CREATE TABLE movies_staging (
    title TEXT,
    genre TEXT,
    duration_min INTEGER,
    year INTEGER,
    age_rating TEXT
);

-- 3. Імпорт CSV через SQLite CLI.
.mode csv
.import --skip 1 "C:/Users/user/Desktop/katashynskakateryna_it31/docs/practice/csv/14-csv-import/v3_new_rows.csv" movies_staging

-- Перевірка завантажених рядків
.mode column
.headers on
SELECT * FROM movies_staging;

-- 4. Перенесення до основної таблиці.
-- Символ '+' прибирається, а рейтинг перетворюється на INTEGER.
INSERT INTO movies (title, genre, duration_min, year, age_rating)
SELECT
    title,
    genre,
    duration_min,
    year,
    CAST(REPLACE(age_rating, '+', '') AS INTEGER)
FROM movies_staging;

-- Перевірка кількості після імпорту: очікується 14 (6 + 8).
SELECT COUNT(*) AS movies_after FROM movies;

-- Перевірка нових фільмів (у цій базі вони отримали ID 7–14).
SELECT id, title, genre, duration_min, year, age_rating
FROM movies
WHERE id BETWEEN 7 AND 14
ORDER BY id;

-- Видалення проміжної таблиці
DROP TABLE movies_staging;

-- Контроль переліку таблиць
.tables

-- 5. Перевірка прямого імпорту виконується окремо на копії:
-- PowerShell:
-- Copy-Item "...\lab_work_16.db" "...\lab_work_16_test.db"
-- sqlite3.exe "...\lab_work_16_test.db"
-- У SQLite CLI:
-- .mode csv
-- .import --skip 1 "C:/Users/user/Desktop/katashynskakateryna_it31/docs/practice/csv/14-csv-import/v3_new_rows.csv" movies
--
-- Очікуваний результат у тестовій базі:
-- expected 6 columns but found 5
-- INSERT failed: datatype mismatch
-- Після невдалого імпорту COUNT(*) у тестовій базі залишився 14.
