-- Практична робота №5
-- Обмеження цілісності даних: NOT NULL, UNIQUE, CHECK, DEFAULT (Варіант 9: Університет)

PRAGMA foreign_keys = ON;

-- -------------------------------------------------------------
-- БАЗОВИЙ СТАН (з попередніх практик)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS university;

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

CREATE TABLE subjects (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    credits INTEGER NOT NULL
);

INSERT INTO subjects (title, credits) VALUES
('Вища математика', 5),
('Програмне забезпечення', 6),
('Бази даних', 4),
('Алгоритми та структури даних', 5),
('Комп’ютерні мережі', 4),
('Операційні системи', 3);

CREATE TABLE grades (
    id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    exam_date TEXT NOT NULL,
    grade INTEGER NOT NULL,
    FOREIGN KEY (student_id) REFERENCES university (id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE RESTRICT
);

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


-- -------------------------------------------------------------
-- ЗАВДАННЯ 1. Додавання NOT NULL до стовпця last_name у таблиці university
-- -------------------------------------------------------------
ALTER TABLE university RENAME TO university_old;

CREATE TABLE university (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,  -- Додано NOT NULL
    first_name TEXT,
    group_name TEXT,
    admission_year INTEGER
);

INSERT INTO university SELECT * FROM university_old;
DROP TABLE university_old;

-- Перевірка помилки NOT NULL (розкоментуйте для перевірки в SQLite):
-- INSERT INTO university (last_name, first_name, group_name, admission_year) VALUES (NULL, 'Тест', 'ІТ-22', 2022);


-- -------------------------------------------------------------
-- ЗАВДАННЯ 2. Додавання UNIQUE до стовпця title у таблиці subjects
-- -------------------------------------------------------------
ALTER TABLE subjects RENAME TO subjects_old;

CREATE TABLE subjects (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL UNIQUE,  -- Додано UNIQUE
    credits INTEGER NOT NULL
);

INSERT INTO subjects SELECT * FROM subjects_old;
DROP TABLE subjects_old;

-- Перевірка помилки UNIQUE (розкоментуйте для перевірки в SQLite):
-- INSERT INTO subjects (title, credits) VALUES ('Вища математика', 5);


-- -------------------------------------------------------------
-- ЗАВДАННЯ 3. Додавання CHECK до стовпця grade у таблиці grades
-- -------------------------------------------------------------
ALTER TABLE grades RENAME TO grades_old;

CREATE TABLE grades (
    id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    exam_date TEXT NOT NULL,
    grade INTEGER NOT NULL CHECK (grade >= 0 AND grade <= 100), -- Додано CHECK
    FOREIGN KEY (student_id) REFERENCES university (id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE RESTRICT
);

INSERT INTO grades SELECT * FROM grades_old;
DROP TABLE grades_old;

-- Перевірка помилки CHECK (розкоментуйте для перевірки в SQLite):
-- INSERT INTO grades (student_id, subject_id, exam_date, grade) VALUES (1, 2, '2026-06-25', 150);


-- -------------------------------------------------------------
-- ЗАВДАННЯ 4. Додавання DEFAULT до стовпця admission_year у таблиці university
-- -------------------------------------------------------------
ALTER TABLE university RENAME TO university_old;

CREATE TABLE university (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT,
    group_name TEXT,
    admission_year INTEGER DEFAULT 2026 -- Додано DEFAULT
);

INSERT INTO university SELECT * FROM university_old;
DROP TABLE university_old;

-- Вставка без вказання admission_year для перевірки DEFAULT:
INSERT INTO university (last_name, first_name, group_name) 
VALUES ('Коваленко', 'Петро', 'ІТ-25');


-- -------------------------------------------------------------
-- ЗАВДАННЯ 5. Перевірка обмеження через UPDATE
-- -------------------------------------------------------------
-- Спроба оновити оцінку на невалідну (порушення CHECK):
-- UPDATE grades SET grade = -10 WHERE id = 1;