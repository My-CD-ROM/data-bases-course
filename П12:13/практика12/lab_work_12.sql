-- Практика 12. Сортування і фільтрація даних
-- Pavlo Dranytskyi, IT-31
-- База: університет (таблиці university, subjects, grades)

-- ===== Завдання 1. ORDER BY за однією колонкою =====
-- Оцінки від найвищої до найнижчої
SELECT id, student_id, subject_id, exam_date, grade
FROM grades
ORDER BY grade DESC;
-- Результат (10 рядк.):
--   id | student_id | subject_id | exam_date | grade
--   7 | 5 | 1 | 2026-05-20 | 95
--   3 | 1 | 3 | 2026-06-02 | 92
--   8 | 5 | 2 | 2026-05-25 | 91
--   1 | 1 | 1 | 2026-05-20 | 90
--   10 | 6 | 3 | 2026-06-02 | 89
--   5 | 3 | 2 | 2026-05-25 | 88
--   2 | 1 | 2 | 2026-05-25 | 85
--   9 | 6 | 1 | 2026-05-20 | 84
--   6 | 3 | 3 | 2026-06-02 | 81
--   4 | 3 | 1 | 2026-05-20 | 78

-- ===== Завдання 2. ORDER BY за кількома колонками =====
-- Спершу за предметом, у межах предмета — від найвищої оцінки
SELECT id, student_id, subject_id, exam_date, grade
FROM grades
ORDER BY subject_id ASC, grade DESC;
-- Результат (10 рядк.):
--   id | student_id | subject_id | exam_date | grade
--   7 | 5 | 1 | 2026-05-20 | 95
--   1 | 1 | 1 | 2026-05-20 | 90
--   9 | 6 | 1 | 2026-05-20 | 84
--   4 | 3 | 1 | 2026-05-20 | 78
--   8 | 5 | 2 | 2026-05-25 | 91
--   5 | 3 | 2 | 2026-05-25 | 88
--   2 | 1 | 2 | 2026-05-25 | 85
--   3 | 1 | 3 | 2026-06-02 | 92
--   10 | 6 | 3 | 2026-06-02 | 89
--   6 | 3 | 3 | 2026-06-02 | 81

-- ===== Завдання 3. Топ-N: ORDER BY + LIMIT =====
-- Три найвищі оцінки
SELECT id, student_id, subject_id, exam_date, grade
FROM grades
ORDER BY grade DESC
LIMIT 3;
-- Результат (3 рядк.):
--   id | student_id | subject_id | exam_date | grade
--   7 | 5 | 1 | 2026-05-20 | 95
--   3 | 1 | 3 | 2026-06-02 | 92
--   8 | 5 | 2 | 2026-05-25 | 91

-- Для порівняння: LIMIT 3 без ORDER BY
SELECT id, student_id, subject_id, exam_date, grade
FROM grades
LIMIT 3;
-- Результат (3 рядк.):
--   id | student_id | subject_id | exam_date | grade
--   1 | 1 | 1 | 2026-05-20 | 90
--   2 | 1 | 2 | 2026-05-25 | 85
--   3 | 1 | 3 | 2026-06-02 | 92

-- ===== Завдання 4. DISTINCT і BETWEEN/IN =====
-- (а) унікальні групи в таблиці university
SELECT DISTINCT group_name
FROM university;
-- Результат (4 рядк.):
--   group_name
--   ІТ-22
--   ІТ-23
--   ІТ-21
--   ІТ-25

-- (а) кількість унікальних груп
SELECT COUNT(DISTINCT group_name) AS unique_groups
FROM university;
-- Результат (1 рядк.):
--   unique_groups
--   4

-- (б) BETWEEN: оцінки від 85 до 95 включно
SELECT id, student_id, subject_id, grade
FROM grades
WHERE grade BETWEEN 85 AND 95
ORDER BY grade;
-- Результат (7 рядк.):
--   id | student_id | subject_id | grade
--   2 | 1 | 2 | 85
--   5 | 3 | 2 | 88
--   10 | 6 | 3 | 89
--   1 | 1 | 1 | 90
--   8 | 5 | 2 | 91
--   3 | 1 | 3 | 92
--   7 | 5 | 1 | 95

-- (б, додатково) IN: предмети з кредитами 3 або 6
SELECT id, title, credits
FROM subjects
WHERE credits IN (3, 6);
-- Результат (2 рядк.):
--   id | title | credits
--   2 | Програмне забезпечення | 6
--   6 | Операційні системи | 3

-- ===== Завдання 5. LIKE і кирилиця =====
-- Прізвища, що починаються на «Ко»
SELECT id, last_name
FROM university
WHERE last_name LIKE 'Ко%';
-- Результат (2 рядк.):
--   id | last_name
--   4 | Ковальчук
--   7 | Коваленко

-- Той самий шаблон з малої літери «ко»
SELECT id, last_name
FROM university
WHERE last_name LIKE 'ко%';
-- Результат (0 рядк.):
--   id | last_name

-- Кількість знайдених рядків для обох варіантів
SELECT
  (SELECT COUNT(*) FROM university WHERE last_name LIKE 'Ко%') AS upper_k,
  (SELECT COUNT(*) FROM university WHERE last_name LIKE 'ко%') AS lower_k;
-- Результат (1 рядк.):
--   upper_k | lower_k
--   2 | 0

-- Контроль: для латиниці регістр ігнорується, для кирилиці — ні
SELECT 'Abc' LIKE 'abc%' AS latin_ci, 'Ко' LIKE 'ко%' AS cyrillic_ci;
-- Результат (1 рядк.):
--   latin_ci | cyrillic_ci
--   1 | 0

-- Додатково: lower() теж не змінює кирилицю
SELECT lower('ABC') AS latin_lower, lower('КОВАЛЬЧУК') AS cyrillic_lower;
-- Результат (1 рядк.):
--   latin_lower | cyrillic_lower
--   abc | КОВАЛЬЧУК
