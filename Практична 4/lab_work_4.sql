-- Практична робота №4
-- Додавання записів, встановлення ключів і зв'язків (Варіант 9: Університет)

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS university;

-- Таблиця-вимір 1 (Студенти) з Практики 1
CREATE TABLE "university" (
    "id" INTEGER PRIMARY KEY,
    "last_name" TEXT,
    "first_name" TEXT,
    "group_name" TEXT,
    "admission_year" INTEGER
);

INSERT INTO university (id, last_name, first_name, group_name, admission_year) VALUES
(1, 'Петренко', 'Олександр', 'ІТ-22', 2022),
(2, 'Іванов', 'Максим', 'ІТ-23', 2023),
(3, 'Сидоренко', 'Марія', 'ІТ-21', 2021),
(4, 'Ковальчук', 'Ірина', 'ІТ-22', 2022),
(5, 'Мельник', 'Андрій', 'ІТ-21', 2021),
(6, 'Бойко', 'Софія', 'ІТ-21', 2021);

-- Завдання 1. Створення таблиці-виміру 2 (Предмети)
CREATE TABLE subjects (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    credits INTEGER NOT NULL
);

-- Завдання 3. Заповнення таблиці-виміру 2 (6 рядків)
INSERT INTO subjects (title, credits) VALUES
('Вища математика', 5),
('Програмне забезпечення', 6),
('Бази даних', 4),
('Алгоритми та структури даних', 5),
('Комп’ютерні мережі', 4),
('Операційні системи', 3);

-- Завдання 2. Створення фактової таблиці (Оцінки) з двома FOREIGN KEY
CREATE TABLE grades (
    id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    exam_date TEXT NOT NULL,
    grade INTEGER NOT NULL,
    FOREIGN KEY (student_id) REFERENCES university (id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE RESTRICT
);

-- Завдання 3. Заповнення фактової таблиці (10 реальних пов'язаних рядків)
INSERT INTO grades (student_id, subject_id, exam_date, grade) VALUES
(1, 1, '2026-06-10', 85),
(1, 3, '2026-06-15', 92),
(2, 2, '2026-06-11', 78),
(3, 1, '2026-06-10', 95),
(3, 4, '2026-06-18', 90),
(4, 2, '2026-06-11', 88),
(4, 5, '2026-06-20', 74),
(5, 3, '2026-06-15', 82),
(6, 6, '2026-06-22', 96),
(2, 4, '2026-06-18', 65);

-- Завдання 4. Навмисна помилка зовнішнього ключа
INSERT INTO grades (student_id, subject_id, exam_date, grade) VALUES (9999, 1, '2026-06-25', 80);