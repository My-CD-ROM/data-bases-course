-- Практична робота №7. Варіант 9 — Університет (деканат)
-- Використано реальну структуру з наданого lab_work_5.db:
-- university, subjects, grades.
-- Структуру БД не змінюємо; у файлі grades наразі немає записів.

-- Завдання 1. INNER JOIN фактова таблиця + вимір 1 (university).
SELECT university.last_name, university.first_name, university.group_name,
       grades.grade, grades.exam_date
FROM grades
INNER JOIN university ON grades.student_id = university.id
ORDER BY university.last_name, grades.exam_date;
-- Результат: 0 рядків.

-- Завдання 2. INNER JOIN усіх трьох таблиць.
SELECT university.last_name, university.first_name, subjects.title,
       grades.grade, grades.exam_date
FROM grades
INNER JOIN university ON grades.student_id = university.id
INNER JOIN subjects ON grades.subject_id = subjects.id
ORDER BY university.last_name, subjects.title;
-- Результат: 0 рядків.

-- Завдання 3. Предмети, для яких ще немає жодної оцінки.
SELECT subjects.title, subjects.credits
FROM subjects
LEFT JOIN grades ON subjects.id = grades.subject_id
WHERE grades.id IS NULL
ORDER BY subjects.title;
-- Результат: 6 рядків.
-- Алгоритми та структури даних | 5
-- Бази даних | 4
-- Вища математика | 5
-- Комп’ютерні мережі | 4
-- Операційні системи | 3
-- Програмне забезпечення | 6

-- Додавати новий рядок не потрібно: у поточній БД таблиця grades порожня,
-- тому запит знаходить усі наявні предмети без оцінок.

-- Завдання 4. Свідома пастка CROSS JOIN.
SELECT COUNT(*) AS cross_join_count FROM university, subjects;
-- Результат: 42

SELECT COUNT(*) AS university_count FROM university;
-- Результат: 7

SELECT COUNT(*) AS subjects_count FROM subjects;
-- Результат: 6
-- Перевірка: 7 * 6 = 42.
