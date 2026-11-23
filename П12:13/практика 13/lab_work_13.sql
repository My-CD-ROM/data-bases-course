-- Практика 13. Форматування таблиць за допомогою printf і дат
-- Pavlo Dranytskyi, IT-31
-- База: університет (таблиці university, subjects, grades)

-- ===== Завдання 1. printf() для числової колонки =====
-- Сире значення оцінки та відформатований текст
SELECT id, grade AS raw_grade, printf('%.2f балів', grade) AS formatted_grade
FROM grades;
-- Результат (10 рядк.):
--   id | raw_grade | formatted_grade
--   1 | 90 | 90.00 балів
--   2 | 85 | 85.00 балів
--   3 | 92 | 92.00 балів
--   4 | 78 | 78.00 балів
--   5 | 88 | 88.00 балів
--   6 | 81 | 81.00 балів
--   7 | 95 | 95.00 балів
--   8 | 91 | 91.00 балів
--   9 | 84 | 84.00 балів
--   10 | 89 | 89.00 балів

-- Тип значення до і після printf()
SELECT typeof(grade) AS raw_type, typeof(printf('%.2f балів', grade)) AS formatted_type
FROM grades
LIMIT 1;
-- Результат (1 рядк.):
--   raw_type | formatted_type
--   integer | text

-- ===== Завдання 2. printf() з вирівнюванням =====
-- Мінімальна ширина поля: '%8.2f' для оцінки і '%05d' для id
SELECT printf('%05d', id) AS padded_id, printf('%8.2f', grade) AS padded_grade
FROM grades;
-- Результат (10 рядк.):
--   padded_id | padded_grade
--   00001 |    90.00
--   00002 |    85.00
--   00003 |    92.00
--   00004 |    78.00
--   00005 |    88.00
--   00006 |    81.00
--   00007 |    95.00
--   00008 |    91.00
--   00009 |    84.00
--   00010 |    89.00

-- ===== Завдання 3. Зсув дати =====
-- Дата перескладання: через 14 днів після іспиту
SELECT id, exam_date, date(exam_date, '+14 days') AS retake_date
FROM grades;
-- Результат (10 рядк.):
--   id | exam_date | retake_date
--   1 | 2026-05-20 | 2026-06-03
--   2 | 2026-05-25 | 2026-06-08
--   3 | 2026-06-02 | 2026-06-16
--   4 | 2026-05-20 | 2026-06-03
--   5 | 2026-05-25 | 2026-06-08
--   6 | 2026-06-02 | 2026-06-16
--   7 | 2026-05-20 | 2026-06-03
--   8 | 2026-05-25 | 2026-06-08
--   9 | 2026-05-20 | 2026-06-03
--   10 | 2026-06-02 | 2026-06-16

-- ===== Завдання 4. strftime() і GROUP BY =====
-- Кількість іспитів за місяцями
SELECT strftime('%Y-%m', exam_date) AS ym, COUNT(*) AS exams_count
FROM grades
GROUP BY ym;
-- Результат (2 рядк.):
--   ym | exams_count
--   2026-05 | 7
--   2026-06 | 3

-- Для порівняння: групування за повною датою
SELECT exam_date, COUNT(*) AS exams_count
FROM grades
GROUP BY exam_date;
-- Результат (3 рядк.):
--   exam_date | exams_count
--   2026-05-20 | 4
--   2026-05-25 | 3
--   2026-06-02 | 3

-- Додатково: strftime() повертає текст, а не число
SELECT strftime('%Y', '2026-05-20') AS year_value,
       typeof(strftime('%Y', '2026-05-20')) AS year_type,
       strftime('%Y', '2026-05-20') = 2026 AS equals_integer,
       CAST(strftime('%Y', '2026-05-20') AS INTEGER) = 2026 AS equals_after_cast;
-- Результат (1 рядк.):
--   year_value | year_type | equals_integer | equals_after_cast
--   2026 | text | 0 | 1

-- ===== Завдання 5. Некоректна дата =====
-- Текстовий літерал, що не є датою
SELECT strftime('%Y', 'not-a-date') AS year_value, date('not-a-date') AS date_value;
-- Результат (1 рядк.):
--   year_value | date_value
--   NULL | NULL

-- Колонка, яка дат не містить (прізвище)
SELECT last_name, strftime('%Y', last_name) AS year_value
FROM university
LIMIT 3;
-- Результат (3 рядк.):
--   last_name | year_value
--   Петренко | NULL
--   Іванов | NULL
--   Сидоренко | NULL

-- Неіснуюча дата 30 лютого та неіснуючий місяць
SELECT date('2026-02-30') AS feb_30, date('2026-13-01') AS month_13;
-- Результат (1 рядк.):
--   feb_30 | month_13
--   2026-03-02 | NULL

-- Додатково: звичайне порівняння date(x) = x виявляє нормалізовану дату
SELECT date('2026-02-30') = '2026-02-30' AS is_same;
-- Результат (1 рядк.):
--   is_same
--   0
