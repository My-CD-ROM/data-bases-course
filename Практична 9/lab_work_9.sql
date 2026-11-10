-- Практична робота №9
-- Варіант 9 — Університет (деканат)
-- Тема: GROUP BY

PRAGMA foreign_keys = OFF;

-- Додаємо тестові оцінки для виконання групування
INSERT INTO grades (student_id, subject_id, exam_date, grade)
VALUES
(1, 1, '2026-05-20', 90),
(1, 2, '2026-05-25', 85),
(1, 3, '2026-06-02', 92),
(3, 1, '2026-05-20', 78),
(3, 2, '2026-05-25', 88),
(3, 3, '2026-06-02', 81),
(5, 1, '2026-05-20', 95),
(5, 2, '2026-05-25', 91),
(6, 1, '2026-05-20', 84),
(6, 3, '2026-06-02', 89);

-- Завдання 1.
-- Кількість оцінок кожного студента

SELECT student_id, COUNT(*) AS grades_count
FROM grades
GROUP BY student_id
ORDER BY student_id;

-- Результат:
-- 1 | 3
-- 3 | 3
-- 5 | 2
-- 6 | 2


-- Завдання 2.
-- Кількість оцінок кожного студента з його ім'ям

SELECT university.id,
       university.last_name,
       university.first_name,
       COUNT(grades.id) AS grades_count
FROM university
LEFT JOIN grades ON grades.student_id = university.id
GROUP BY university.id
ORDER BY university.id;

-- Результат:
-- 1 | Петренко | Олександр | 3
-- 2 | Іванов | Максим | 0
-- 3 | Сидоренко | Марія | 3
-- 4 | Ковальчук | Ірина | 0
-- 5 | Мельник | Андрій | 2
-- 6 | Бойко | Софія | 2
-- 7 | Коваленко | NULL | 0


-- Завдання 3.
-- Кількість оцінок та середній бал по кожному предмету

SELECT subject_id,
       COUNT(*) AS grades_count,
       ROUND(AVG(grade), 2) AS average_grade
FROM grades
GROUP BY subject_id
ORDER BY subject_id;

-- Результат:
-- 1 | 4 | 86.75
-- 2 | 3 | 88.00
-- 3 | 3 | 87.33


-- Завдання 4.
-- Групування за двома колонками

SELECT student_id,
       subject_id,
       COUNT(*) AS records_count
FROM grades
GROUP BY student_id, subject_id
ORDER BY student_id, subject_id;

-- Результат:
-- 1 | 1 | 1
-- 1 | 2 | 1
-- 1 | 3 | 1
-- 3 | 1 | 1
-- 3 | 2 | 1
-- 3 | 3 | 1
-- 5 | 1 | 1
-- 5 | 2 | 1
-- 6 | 1 | 1
-- 6 | 3 | 1

-- Унікальних студентів: 4
-- Унікальних предметів: 3
-- Унікальних пар: 10


-- Завдання 5.
-- Колонка exam_date не входить до GROUP BY

SELECT subject_id,
       exam_date,
       COUNT(*) AS grades_count
FROM grades
GROUP BY subject_id
ORDER BY subject_id;

-- Повторно виконуємо той самий запит

SELECT subject_id,
       exam_date,
       COUNT(*) AS grades_count
FROM grades
GROUP BY subject_id
ORDER BY subject_id;

-- SQLite дозволяє такий запит,
-- але значення exam_date не гарантоване.