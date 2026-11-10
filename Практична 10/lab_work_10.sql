-- Практична робота №10. Варіант 9 — Університет (деканат).
-- Таблиці: university, subjects, grades.
-- Структуру БД не змінюємо.
-- У поточній базі grades порожня, тому запити до фактів повертають 0 рядків.

-- Завдання 1. HAVING на COUNT.
SELECT student_id, COUNT(*) AS grades_count
FROM grades
GROUP BY student_id
HAVING COUNT(*) > 2;
-- Результат: 0 рядків.

-- Завдання 2. HAVING на AVG.
SELECT subject_id, AVG(grade) AS average_grade
FROM grades
GROUP BY subject_id
HAVING AVG(grade) >= 80;
-- Результат: 0 рядків.

-- Завдання 3. WHERE + GROUP BY + HAVING.
SELECT student_id, AVG(grade) AS average_grade
FROM grades
WHERE grade >= 60
GROUP BY student_id
HAVING AVG(grade) > 80;
-- Результат: 0 рядків.

-- Завдання 4. Навмисно неправильний запит: агрегат у WHERE.
SELECT student_id, COUNT(*) AS grades_count
FROM grades
WHERE COUNT(*) > 1
GROUP BY student_id;
-- Точний текст помилки SQLite: misuse of aggregate: COUNT()
-- Причина: WHERE виконується до GROUP BY, коли агрегатні групи ще не сформовані.

-- Завдання 5. LEFT JOIN + GROUP BY + HAVING.
SELECT university.id, university.last_name, university.first_name,
       COUNT(grades.id) AS grades_count
FROM university
LEFT JOIN grades ON university.id = grades.student_id
GROUP BY university.id
HAVING COUNT(grades.id) < 1
ORDER BY university.id;
-- Результат: 7 рядків; для кожного студента grades_count = 0.
