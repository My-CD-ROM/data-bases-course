-- Драницький Павло, група ІТ-31, варіант 9 (Університет)
-- Практика 14. Створення та відкат транзакцій у SQLite
-- SQLite 3.45.1

-- ============================================================
-- Стан до початку
-- ============================================================
SELECT COUNT(*) FROM grades;
-- Результат:
--   10
SELECT * FROM grades WHERE student_id IN (4,6) ORDER BY id;
-- Результат:
--   9 | 6 | 1 | 2026-05-20 | 84
--   10 | 6 | 3 | 2026-06-02 | 89
SELECT id, title, credits FROM subjects WHERE id = 6;
-- Результат:
--   6 | Операційні системи | 3

-- ============================================================
-- Завдання 1. Атомарна пара UPDATE + INSERT (виправлення помилково внесеної оцінки)
-- ============================================================
-- Оцінка id=10 (дисципліна 3, 2026-06-02) була внесена на студента 6, а належить студенту 4.
-- Виправлення = перепризначити запис на студента 4 + внести справжню оцінку студента 6.
BEGIN;
UPDATE grades SET student_id = 4 WHERE id = 10;
INSERT INTO grades (student_id, subject_id, exam_date, grade) VALUES (6, 3, '2026-06-02', 87);
COMMIT;
SELECT * FROM grades WHERE subject_id = 3 AND exam_date = '2026-06-02' ORDER BY id;
-- Результат:
--   3 | 1 | 3 | 2026-06-02 | 92
--   6 | 3 | 3 | 2026-06-02 | 81
--   10 | 4 | 3 | 2026-06-02 | 89
--   11 | 6 | 3 | 2026-06-02 | 87

-- ============================================================
-- Завдання 2. Свідомий ROLLBACK
-- ============================================================
-- до BEGIN: кількість оцінок
SELECT COUNT(*) FROM grades;
-- Результат:
--   11
-- до BEGIN: кредити дисципліни 1
SELECT credits FROM subjects WHERE id = 1;
-- Результат:
--   5
BEGIN;
INSERT INTO grades (student_id, subject_id, exam_date, grade) VALUES (7, 1, '2026-06-10', 70);
UPDATE subjects SET credits = credits + 1 WHERE id = 1;
ROLLBACK;
-- після ROLLBACK: кількість оцінок
SELECT COUNT(*) FROM grades;
-- Результат:
--   11
-- після ROLLBACK: кредити дисципліни 1
SELECT credits FROM subjects WHERE id = 1;
-- Результат:
--   5
-- оцінок студента 7
SELECT COUNT(*) FROM grades WHERE student_id = 7;
-- Результат:
--   0

-- ============================================================
-- Завдання 3. Проміжний стан усередині транзакції
-- ============================================================
BEGIN;
UPDATE subjects SET credits = 7 WHERE id = 6;
-- у цій самій сесії, до COMMIT
SELECT id, title, credits FROM subjects WHERE id = 6;
-- Результат:
--   6 | Операційні системи | 7
ROLLBACK;
-- після ROLLBACK
SELECT id, title, credits FROM subjects WHERE id = 6;
-- Результат:
--   6 | Операційні системи | 3

-- ============================================================
-- Завдання 4. Свідома помилка всередині транзакції
-- ============================================================
BEGIN;
-- успішна зміна
INSERT INTO grades (student_id, subject_id, exam_date, grade) VALUES (7, 2, '2026-06-15', 75);
-- помилка: title UNIQUE, 'Бази даних' уже є
INSERT INTO subjects (title, credits) VALUES ('Бази даних', 4);
-- Помилка: Runtime error: UNIQUE constraint failed: subjects.title (19)
-- транзакція ще відкрита: перша зміна на місці?
SELECT * FROM grades WHERE student_id = 7;
-- Результат:
--   12 | 7 | 2 | 2026-06-15 | 75
ROLLBACK;
-- після ROLLBACK
SELECT * FROM grades WHERE student_id = 7;
-- Результат:

-- ============================================================
-- Завдання 5. Забутий ROLLBACK: COMMIT після помилки
-- ============================================================
BEGIN;
INSERT INTO grades (student_id, subject_id, exam_date, grade) VALUES (7, 2, '2026-06-15', 75);
INSERT INTO subjects (title, credits) VALUES ('Бази даних', 4);
-- Помилка: Runtime error: UNIQUE constraint failed: subjects.title (19)
COMMIT;
-- перша зміна зафіксована
SELECT * FROM grades WHERE student_id = 7;
-- Результат:
--   12 | 7 | 2 | 2026-06-15 | 75
-- дубліката немає
SELECT COUNT(*) FROM subjects WHERE title = 'Бази даних';
-- Результат:
--   1
SELECT COUNT(*) FROM subjects;
-- Результат:
--   6
