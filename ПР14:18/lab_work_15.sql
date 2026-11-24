-- Драницький Павло, група ІТ-31, варіант 9 (Університет)
-- Практика 15. Створення індексів та аналіз ефективності запитів
-- SQLite 3.45.1

-- ============================================================
-- Завдання 1. EXPLAIN QUERY PLAN до індексу
-- ============================================================
EXPLAIN QUERY PLAN SELECT * FROM grades WHERE student_id = 1;
-- Результат:
--   QUERY PLAN
--   `--SCAN grades

-- ============================================================
-- Завдання 2. CREATE INDEX на зовнішньому ключі
-- ============================================================
CREATE INDEX idx_grades_student ON grades(student_id);
EXPLAIN QUERY PLAN SELECT * FROM grades WHERE student_id = 1;
-- Результат:
--   QUERY PLAN
--   `--SEARCH grades USING INDEX idx_grades_student (student_id=?)

-- ============================================================
-- Завдання 3. Композитний індекс
-- ============================================================
-- до композитного (є лише idx_grades_student)
EXPLAIN QUERY PLAN SELECT * FROM grades WHERE student_id = 1 AND subject_id = 2;
-- Результат:
--   QUERY PLAN
--   `--SEARCH grades USING INDEX idx_grades_student (student_id=?)
CREATE INDEX idx_grades_student_subject ON grades(student_id, subject_id);
-- після композитного
EXPLAIN QUERY PLAN SELECT * FROM grades WHERE student_id = 1 AND subject_id = 2;
-- Результат:
--   QUERY PLAN
--   `--SEARCH grades USING INDEX idx_grades_student_subject (student_id=? AND subject_id=?)

-- ============================================================
-- Завдання 4. Індекс і ORDER BY
-- ============================================================
-- до індексу
EXPLAIN QUERY PLAN SELECT * FROM grades ORDER BY exam_date;
-- Результат:
--   QUERY PLAN
--   |--SCAN grades
--   `--USE TEMP B-TREE FOR ORDER BY
CREATE INDEX idx_grades_date ON grades(exam_date);
-- після індексу
EXPLAIN QUERY PLAN SELECT * FROM grades ORDER BY exam_date;
-- Результат:
--   QUERY PLAN
--   `--SCAN grades USING INDEX idx_grades_date

-- ============================================================
-- Завдання 5. DROP INDEX і повторна перевірка
-- ============================================================
DROP INDEX idx_grades_student;
-- запит із Завдання 1
EXPLAIN QUERY PLAN SELECT * FROM grades WHERE student_id = 1;
-- Результат:
--   QUERY PLAN
--   `--SEARCH grades USING INDEX idx_grades_student_subject (student_id=?)
SELECT name, tbl_name FROM sqlite_master WHERE type = 'index' ORDER BY name;
-- Результат:
--   idx_grades_date | grades
--   idx_grades_student_subject | grades
--   sqlite_autoindex_subjects_1 | subjects
-- видалений індекс у списку?
SELECT COUNT(*) FROM sqlite_master WHERE type = 'index' AND name = 'idx_grades_student';
-- Результат:
--   0
