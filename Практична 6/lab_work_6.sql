-- Практична робота №6
-- Робота з командами оновлення та видалення у SQLite (Варіант 9: Університет)

PRAGMA foreign_keys = ON;

-- -------------------------------------------------------------
-- БАЗОВА СХЕМА З ОБМЕЖЕННЯМИ (з Практик 4 та 5)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS university;

CREATE TABLE "university" (
    "id" INTEGER PRIMARY KEY,
    "last_name" TEXT NOT NULL,
    "first_name" TEXT,
    "group_name" TEXT,
    "admission_year" INTEGER DEFAULT 2026
);

INSERT INTO university (id, last_name, first_name, group_name, admission_year) VALUES
(1, 'Петренко', 'Олександр', 'ІТ-22', 2022),
(2, 'Іванов', 'Максим', 'ІТ-23', 2023),
(3, 'Сидоренко', 'Марія', 'ІТ-21', 2021),
(4, 'Ковальчук', 'Ірина', 'ІТ-22', 2022),
(5, 'Мельник', 'Андрій', 'ІТ-21', 2021),
(6, 'Бойко', 'Софія', 'ІТ-21', 2021);

CREATE TABLE subjects (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL UNIQUE,
    credits INTEGER NOT NULL
);

INSERT INTO subjects (id, title, credits) VALUES
(1, 'Вища математика', 5),
(2, 'Програмне забезпечення', 6),
(3, 'Бази даних', 4),
(4, 'Алгоритми та структури даних', 5),
(5, 'Комп’ютерні мережі', 4),
(6, 'Операційні системи', 3);

CREATE TABLE grades (
    id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    exam_date TEXT NOT NULL,
    grade INTEGER NOT NULL CHECK (grade >= 0 AND grade <= 100),
    status TEXT DEFAULT 'очікується',
    FOREIGN KEY (student_id) REFERENCES university (id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE RESTRICT
);

INSERT INTO grades (id, student_id, subject_id, exam_date, grade, status) VALUES
(1, 1, 1, '2026-06-10', 85, 'здано'),
(2, 1, 3, '2026-06-15', 92, 'здано'),
(3, 2, 2, '2026-06-11', 78, 'здано'),
(4, 3, 1, '2026-06-10', 95, 'здано'),
(5, 3, 4, '2026-06-18', 90, 'здано'),
(6, 4, 2, '2026-06-11', 88, 'здано'),
(7, 4, 5, '2026-06-20', 74, 'здано'),
(8, 5, 3, '2026-06-15', 82, 'здано'),
(9, 6, 6, '2026-06-22', 96, 'здано'),
(10, 2, 4, '2026-06-18', 65, 'очікується');


-- -------------------------------------------------------------
-- ЗАВДАННЯ 1. UPDATE у фактовій таблиці (grades)
-- Оновлення статусу та оцінки за id
-- -------------------------------------------------------------
UPDATE grades 
SET status = 'перездача', grade = 68 
WHERE id = 10;


-- -------------------------------------------------------------
-- ЗАВДАННЯ 2. UPDATE у таблиці-вимірі (university)
-- Зміна групи студента
-- -------------------------------------------------------------
UPDATE university 
SET group_name = 'ІТ-22' 
WHERE id = 2;


-- -------------------------------------------------------------
-- ЗАВДАННЯ 3. DELETE одного рядка з фактової таблиці за id
-- -------------------------------------------------------------
SELECT COUNT(*) FROM grades;

DELETE FROM grades 
WHERE id = 10;

SELECT COUNT(*) FROM grades;


-- -------------------------------------------------------------
-- ЗАВДАННЯ 4. Перевірка ON DELETE на реальних даних (RESTRICT)
-- Спроба видалити предмет, на який посилаються оцінки
-- -------------------------------------------------------------
DELETE FROM subjects 
WHERE id = 1;