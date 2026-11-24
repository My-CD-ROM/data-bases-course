-- Драницький Павло, група ІТ-31, варіант 9 (Університет)
-- Практика 16. Імпорт даних із CSV у SQLite
-- SQLite 3.45.1

-- ============================================================
-- Підготовка: у subjects немає колонки semester, яка є в CSV
-- ============================================================
-- У CSV три колонки (title, credits, semester), а в таблиці subjects лише дві.
-- Додаємо колонку, щоб було куди імпортувати (наявні рядки отримають NULL).
ALTER TABLE subjects ADD COLUMN semester INTEGER;

-- ============================================================
-- Завдання 1. Підрахунок до імпорту
-- ============================================================
SELECT COUNT(*) FROM subjects;
-- Результат:
--   6

-- ============================================================
-- Завдання 2. Проміжна таблиця й імпорт CSV
-- ============================================================
CREATE TABLE subjects_staging (
    title TEXT,
    credits INTEGER,
    semester INTEGER
);
.mode csv
.import --skip 1 v9_new_rows.csv subjects_staging
-- (імпорт виконано дот-командами вище; попереджень: 0)
SELECT * FROM subjects_staging;
-- Результат:
--   Хмарні обчислення | 4 | 6
--   Проєктування ПЗ | 5 | 4
--   Компʼютерна графіка | 4 | 5
--   Криптографія | 5 | 6
--   Технології баз даних (NoSQL) | 4 | 6
--   Мобільна розробка | 5 | 5
--   Тестування ПЗ | 3 | 4
--   Управління IT-проєктами | 3 | 7
SELECT COUNT(*) FROM subjects_staging;
-- Результат:
--   8

-- ============================================================
-- Завдання 3. Перенесення в реальну таблицю
-- ============================================================
INSERT INTO subjects (title, credits, semester)
SELECT title, credits, semester FROM subjects_staging;
DROP TABLE subjects_staging;
-- було 6, має стати 14 (приріст 8)
SELECT COUNT(*) FROM subjects;
-- Результат:
--   14

-- ============================================================
-- Завдання 4. Перевірка конкретних нових рядків
-- ============================================================
SELECT id, title, credits, semester FROM subjects
WHERE title IN ('Хмарні обчислення', 'Проєктування ПЗ', 'Компʼютерна графіка', 'Криптографія',
                'Технології баз даних (NoSQL)', 'Мобільна розробка', 'Тестування ПЗ', 'Управління IT-проєктами')
ORDER BY id;
-- Результат:
--   7 | Хмарні обчислення | 4 | 6
--   8 | Проєктування ПЗ | 5 | 4
--   9 | Компʼютерна графіка | 4 | 5
--   10 | Криптографія | 5 | 6
--   11 | Технології баз даних (NoSQL) | 4 | 6
--   12 | Мобільна розробка | 5 | 5
--   13 | Тестування ПЗ | 3 | 4
--   14 | Управління IT-проєктами | 3 | 7
-- старі рядки (id 1-6) мають semester IS NULL
SELECT MAX(id) FROM subjects WHERE semester IS NULL;
-- Результат:
--   6

-- ============================================================
-- Завдання 5. Свідома помилка прямого імпорту (на окремій копії БД, НЕ на робочій)
-- ============================================================
.open test16.db
.mode csv
.import --skip 1 v9_new_rows.csv subjects
-- Повідомлення консолі (ПЕРЕВІР у своєму sqlite3, формат за методичкою):
--   v9_new_rows.csv:2: expected 4 columns but found 3 - filling the rest with NULL
--   v9_new_rows.csv:2: INSERT failed: datatype mismatch
--   v9_new_rows.csv:3: expected 4 columns but found 3 - filling the rest with NULL
--   v9_new_rows.csv:3: INSERT failed: datatype mismatch
--   v9_new_rows.csv:4: expected 4 columns but found 3 - filling the rest with NULL
--   v9_new_rows.csv:4: INSERT failed: datatype mismatch
--   ... (так для кожного з 8 рядків файлу)
SELECT COUNT(*) FROM subjects;
-- Результат:
--   14
.open lab_work_16.db
