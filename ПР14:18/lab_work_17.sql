-- Драницький Павло, група ІТ-31, варіант 9 (Університет)
-- Практика 17. Імпорт CSV: типові проблеми, перевірка й експорт
-- SQLite 3.45.1

-- ============================================================
-- Завдання 1. Огляд файлу й «наївний» імпорт
-- ============================================================
-- У файлі v9_raw_rows.csv 10 записів (+ рядок заголовків), роздільник ';'.
CREATE TABLE subjects_staging (
    title TEXT,
    credits INTEGER,
    semester INTEGER
);
.mode csv
.import --skip 1 v9_raw_rows.csv subjects_staging
-- Попередження консолі (ПЕРЕВІР у своєму sqlite3):
--   v9_raw_rows.csv:2: expected 3 columns but found 1 - filling the rest with NULL
--   v9_raw_rows.csv:3: expected 3 columns but found 1 - filling the rest with NULL
--   v9_raw_rows.csv:4: expected 3 columns but found 1 - filling the rest with NULL
--   v9_raw_rows.csv:5: expected 3 columns but found 2 - filling the rest with NULL
--   v9_raw_rows.csv:6: expected 3 columns but found 1 - filling the rest with NULL
--   v9_raw_rows.csv:7: expected 3 columns but found 1 - filling the rest with NULL
--   v9_raw_rows.csv:8: expected 3 columns but found 1 - filling the rest with NULL
--   v9_raw_rows.csv:9: expected 3 columns but found 1 - filling the rest with NULL
--   v9_raw_rows.csv:10: expected 3 columns but found 1 - filling the rest with NULL
--   v9_raw_rows.csv:11: expected 3 columns but found 1 - filling the rest with NULL
SELECT COUNT(*) FROM subjects_staging;
-- Результат:
--   10
SELECT * FROM subjects_staging LIMIT 1;
-- Результат:
--   Дискретна математика;4;1 | NULL | NULL
DELETE FROM subjects_staging;

-- ============================================================
-- Завдання 2. Правильний імпорт із роздільником ;
-- ============================================================
.mode csv
.separator ";"
.import --skip 1 v9_raw_rows.csv subjects_staging
-- Попереджень: 0
SELECT COUNT(*) FROM subjects_staging;
-- Результат:
--   10
SELECT * FROM subjects_staging;
-- Результат:
--   Дискретна математика | 4 | 1
--   Операційні системи | 5 | 3
--   Веб-програмування | 4 | 5
--   Математичний аналіз, частина 2 | 5 | 2
--   Алгоритми і структури даних | 5 | 3
--   Англійська мова фахового спрямування | 3 | 2
--   Кібербезпека | 4 | 
--   Компʼютерні мережі | 4 | 4
--   Штучний інтелект | 5 | 
--   Операційні системи | 5 | 3

-- ============================================================
-- Завдання 3. Контроль якості в проміжній таблиці
-- ============================================================
-- обмеження цільової таблиці (.schema subjects)
SELECT sql FROM sqlite_master WHERE name = 'subjects';
-- Результат:
--   CREATE TABLE subjects (
--       id INTEGER PRIMARY KEY,
--       title TEXT NOT NULL UNIQUE,  -- Додано UNIQUE
--       credits INTEGER NOT NULL
--   , semester INTEGER)
SELECT SUM(title = '') AS title_empty, SUM(credits = '') AS credits_empty, SUM(semester = '') AS semester_empty
FROM subjects_staging;
-- Результат:
--   0 | 0 | 2
SELECT typeof(credits), typeof(semester), COUNT(*) FROM subjects_staging GROUP BY 1, 2;
-- Результат:
--   integer | integer | 8
--   integer | text | 2
SELECT title, credits, semester, COUNT(*) AS cnt FROM subjects_staging
GROUP BY title, credits, semester HAVING COUNT(*) > 1;
-- Результат:
--   Операційні системи | 5 | 3 | 2
-- які саме рядки з порожнім semester
SELECT title, semester FROM subjects_staging WHERE semester = '';
-- Результат:
--   Кібербезпека | 
--   Штучний інтелект | 
-- рядки, які вже є в subjects (з урахуванням двох видів апострофа ’ і ʼ)
SELECT s.title, s.credits, t.id, t.title, t.credits FROM subjects_staging s
JOIN subjects t ON replace(t.title, '’', 'ʼ') = replace(s.title, '’', 'ʼ');
-- Результат:
--   Операційні системи | 5 | 6 | Операційні системи | 3
--   Компʼютерні мережі | 4 | 5 | Комп’ютерні мережі | 4
--   Операційні системи | 5 | 6 | Операційні системи | 3
-- розрахунок: скільки рядків має додатися
SELECT COUNT(*) FROM (SELECT DISTINCT title, credits, semester FROM subjects_staging s
  WHERE NOT EXISTS (SELECT 1 FROM subjects t WHERE replace(t.title, '’', 'ʼ') = replace(s.title, '’', 'ʼ')));
-- Результат:
--   7

-- ============================================================
-- Завдання 4. Перенесення з виправленням
-- ============================================================
-- до перенесення
SELECT COUNT(*), MAX(id) FROM subjects;
-- Результат:
--   14 | 14
INSERT INTO subjects (title, credits, semester)
SELECT DISTINCT title, credits, NULLIF(semester, '')
FROM subjects_staging s
WHERE NOT EXISTS (SELECT 1 FROM subjects t
                  WHERE replace(t.title, '’', 'ʼ') = replace(s.title, '’', 'ʼ'));
-- після перенесення
SELECT COUNT(*), MAX(id) FROM subjects;
-- Результат:
--   21 | 21
SELECT id, title, credits, semester FROM subjects WHERE id > 14 ORDER BY id;
-- Результат:
--   15 | Дискретна математика | 4 | 1
--   16 | Веб-програмування | 4 | 5
--   17 | Математичний аналіз, частина 2 | 5 | 2
--   18 | Алгоритми і структури даних | 5 | 3
--   19 | Англійська мова фахового спрямування | 3 | 2
--   20 | Кібербезпека | 4 | NULL
--   21 | Штучний інтелект | 5 | NULL
-- рядки, що мали порожнє поле
SELECT id, title FROM subjects WHERE id > 14 AND semester IS NULL;
-- Результат:
--   20 | Кібербезпека
--   21 | Штучний інтелект
DROP TABLE subjects_staging;

-- ============================================================
-- Завдання 5. Експорт у CSV
-- ============================================================
.headers on
.mode csv
.output subjects_export.csv
SELECT id, title, credits, semester FROM subjects WHERE id > 14;
-- Результат:
--   15 | Дискретна математика | 4 | 1
--   16 | Веб-програмування | 4 | 5
--   17 | Математичний аналіз, частина 2 | 5 | 2
--   18 | Алгоритми і структури даних | 5 | 3
--   19 | Англійська мова фахового спрямування | 3 | 2
--   20 | Кібербезпека | 4 | NULL
--   21 | Штучний інтелект | 5 | NULL
.output stdout
