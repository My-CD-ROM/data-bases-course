-- Завдання 1
SELECT
    grades.grade,
    grades.grade_date,
    courses.title
FROM grades
INNER JOIN courses
    ON grades.course_id = courses.id
ORDER BY grades.grade_date;

-- Результат:
-- 75|2026-09-01|Вища математика
-- 85|2026-09-02|Програмування
-- 60|2026-09-02|Програмування
-- 88|2026-09-04|Алгоритми та структури даних
-- 78|2026-09-04|Алгоритми та структури даних
-- 92|2026-09-05|Веб-розробка


-- Завдання 2
SELECT
    courses.title,
    students.last_name,
    students.first_name,
    grades.grade,
    grades.grade_date
FROM grades
INNER JOIN courses
    ON grades.course_id = courses.id
INNER JOIN students
    ON grades.student_id = students.id
ORDER BY grades.grade_date;

-- Результат:
-- Вища математика|Carter|Emily|75|2026-09-01
-- Програмування|Wilson|James|85|2026-09-02
-- Програмування|Miller|Daniel|60|2026-09-02
-- Алгоритми та структури даних|Taylor|Sophie|88|2026-09-04
-- Алгоритми та структури даних|Carter|Emily|78|2026-09-04
-- Веб-розробка|Anderson|Chloe|92|2026-09-05


-- Завдання 3
SELECT
    courses.title
FROM courses
LEFT JOIN grades
    ON grades.course_id = courses.id
WHERE grades.id IS NULL;

-- Результат:
-- Тест CHECK 2
-- Тест DEFAULT


-- Завдання 4
SELECT COUNT(*) FROM courses;

-- Результат:
-- 6


SELECT COUNT(*) FROM students;

-- Результат:
-- 6


SELECT COUNT(*) FROM courses, students;

-- Результат:
-- 36

-- Пояснення:
-- CROSS JOIN створює всі можливі комбінації рядків двох таблиць. У базі є 6 курсів і 6 студентів,
-- тому кількість комбінацій становить 6 * 6 = 36.
-- Це добуток, а не сума. У реальному звіті такий
-- запит майже завжди є помилкою, оскільки створює
-- комбінації рядків, між якими немає потрібного зв'язку.