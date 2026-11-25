-- Практична робота №17
-- Імпорт даних із CSV у SQLite: типові проблеми, перевірка й експорт
-- Варіант 3: кінотеатр
--
-- Перед запуском:
-- 1. Створіть копію lab_work_16.db під назвою lab_work_17.db.
-- 2. Запускайте скрипт із SQLite CLI у контексті lab_work_17.db.
-- 3. Перевірте та за потреби змініть шлях до вхідного CSV і шлях експорту.
--
-- Вхідний файл:
-- C:/Users/user/OneDrive/Desktop/data-bases-course/docs/practice/csv/17-csv-import-2/v3_raw_rows.csv
--
-- Увага: перший імпорт навмисно виконується з неправильним роздільником
-- для демонстрації проблеми. Після нього staging-таблиця очищується.

-- 1. Створення staging-таблиці без обмежень NOT NULL.
CREATE TABLE IF NOT EXISTS movies_staging (
    title TEXT,
    genre TEXT,
    duration_min INTEGER,
    year INTEGER,
    age_rating INTEGER
);

-- 2. Демонстрація неправильного імпорту.
.mode csv
.import --skip 1 "C:/Users/user/OneDrive/Desktop/data-bases-course/docs/practice/csv/17-csv-import-2/v3_raw_rows.csv" movies_staging

-- Перевірка результату неправильного імпорту:
SELECT COUNT(*) AS rows_after_wrong_import FROM movies_staging;
SELECT title AS first_imported_title FROM movies_staging LIMIT 1;

-- Очищення staging після неправильного імпорту.
DELETE FROM movies_staging;

-- 3. Правильний імпорт із роздільником крапка з комою.
.mode csv
.separator ";"
.import --skip 1 "C:/Users/user/OneDrive/Desktop/data-bases-course/docs/practice/csv/17-csv-import-2/v3_raw_rows.csv" movies_staging

-- Перевірка кількості імпортованих рядків.
SELECT COUNT(*) AS staging_rows FROM movies_staging;

-- 4. Перевірка порожніх рядкових значень.
SELECT
    SUM(title = '') AS empty_title,
    SUM(genre = '') AS empty_genre,
    SUM(duration_min = '') AS empty_duration,
    SUM(year = '') AS empty_year,
    SUM(age_rating = '') AS empty_age_rating
FROM movies_staging;

-- Перевірка фактичних типів значень у числових полях.
SELECT
    typeof(duration_min) AS duration_type,
    typeof(year) AS year_type,
    typeof(age_rating) AS age_rating_type,
    COUNT(*) AS records
FROM movies_staging
GROUP BY duration_type, year_type, age_rating_type;

-- Пошук дублікатів за всіма полями.
SELECT title, genre, duration_min, year, age_rating, COUNT(*) AS copies
FROM movies_staging
GROUP BY title, genre, duration_min, year, age_rating
HAVING COUNT(*) > 1;

-- Перевірка структури та стану основної таблиці перед вставленням.
.schema movies
SELECT COUNT(*) AS movies_before, MAX(id) AS max_id_before
FROM movies;

-- 5. Додавання повних унікальних записів.
-- Порожні значення у duration_min відкидаються, оскільки поле NOT NULL.
-- DISTINCT усуває дублікати в staging.
-- NOT EXISTS не дозволяє повторно додати запис, який уже є в movies.
INSERT INTO movies (title, genre, duration_min, year, age_rating)
SELECT DISTINCT
    title,
    genre,
    CAST(NULLIF(duration_min, '') AS INTEGER),
    CAST(NULLIF(year, '') AS INTEGER),
    CAST(NULLIF(age_rating, '') AS INTEGER)
FROM movies_staging
WHERE title != ''
  AND genre != ''
  AND duration_min != ''
  AND year != ''
  AND age_rating != ''
  AND NOT EXISTS (
      SELECT 1
      FROM movies
      WHERE movies.title = movies_staging.title
        AND movies.genre = movies_staging.genre
        AND movies.duration_min = CAST(movies_staging.duration_min AS INTEGER)
        AND movies.year = CAST(movies_staging.year AS INTEGER)
        AND movies.age_rating = CAST(movies_staging.age_rating AS INTEGER)
  );

-- Перевірка результату вставлення.
SELECT COUNT(*) AS movies_after, MAX(id) AS max_id_after
FROM movies;

SELECT *
FROM movies
WHERE id > 14
ORDER BY id;

-- Перевірка відсутності NULL у полях із NOT NULL.
SELECT COUNT(*) AS incomplete_movies
FROM movies
WHERE title IS NULL
   OR genre IS NULL
   OR duration_min IS NULL
   OR year IS NULL
   OR age_rating IS NULL;

-- 6. Видалення staging-таблиці після завершення імпорту.
DELETE FROM movies_staging;
DROP TABLE movies_staging;

-- 7. Експорт доданих записів у CSV із заголовками.
.headers on
.mode csv
.output "C:/Users/user/OneDrive/Desktop/practices_BD/practice10/practice17_export.csv"
SELECT title, genre, duration_min, year, age_rating
FROM movies
WHERE id BETWEEN 15 AND 21
ORDER BY id;
.output stdout

-- 8. Фінальна перевірка.
SELECT COUNT(*) AS final_movies_count FROM movies;
.tables
