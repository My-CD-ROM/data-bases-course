DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    group_name TEXT,
    admission_year INTEGER
);
CREATE TABLE courses (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    credits INTEGER,
    semester INTEGER
);
CREATE TABLE grades (
    id INTEGER PRIMARY KEY,
    student_id INTEGER REFERENCES students(id),
    course_id INTEGER REFERENCES courses(id),
    grade INTEGER,
    grade_date TEXT
);
INSERT INTO students VALUES (1, 'Іванов', 'Тарас', 'КН-38', 2025);
INSERT INTO students VALUES (2, 'Ткаченко', 'Софія', 'КН-24', 2025);
INSERT INTO students VALUES (3, 'Бондаренко', 'Богдан', 'КН-22', 2023);
INSERT INTO students VALUES (4, 'Захарченко', 'Софія', 'КН-39', 2023);
INSERT INTO students VALUES (5, 'Савченко', 'Роман', 'КН-20', 2022);
INSERT INTO students VALUES (6, 'Савченко', 'Тетяна', 'КН-13', 2024);
INSERT INTO students VALUES (7, 'Литвин', 'Андрій', 'КН-43', 2021);
INSERT INTO students VALUES (8, 'Ткаченко', 'Олег', 'КН-27', 2024);
INSERT INTO students VALUES (9, 'Гриценко', 'Дарина', 'КН-15', 2022);
INSERT INTO students VALUES (10, 'Литвин', 'Ігор', 'КН-11', 2024);
INSERT INTO students VALUES (11, 'Іванов', 'Ігор', 'КН-25', 2024);
INSERT INTO students VALUES (12, 'Коваль', 'Петро', 'КН-30', 2021);
INSERT INTO courses VALUES (1, 'Бази даних', 5, 3);
INSERT INTO courses VALUES (2, 'Алгоритми і структури даних', 6, 2);
INSERT INTO courses VALUES (3, 'Об''єктно-орієнтоване програмування', 5, 2);
INSERT INTO courses VALUES (4, 'Web-технології', 4, 4);
INSERT INTO courses VALUES (5, 'Комп''ютерні мережі', 4, 3);
INSERT INTO courses VALUES (6, 'Операційні системи', 5, 3);
INSERT INTO courses VALUES (7, 'Дискретна математика', 6, 1);
INSERT INTO courses VALUES (8, 'Машинне навчання', 5, 5);
INSERT INTO courses VALUES (9, 'Інформаційна безпека', 4, 4);
INSERT INTO courses VALUES (10, 'Теорія ймовірностей', 5, 2);
INSERT INTO courses VALUES (11, 'Архітектура ЕОМ', 4, 3);
INSERT INTO courses VALUES (12, 'Проєктний менеджмент', 3, 5);
INSERT INTO grades VALUES (1, 12, 11, 85, '2024-03-02');
INSERT INTO grades VALUES (2, 5, 8, 70, '2025-08-20');
INSERT INTO grades VALUES (3, 1, 2, 60, '2025-04-27');
INSERT INTO grades VALUES (4, 3, 9, 100, '2025-02-25');
INSERT INTO grades VALUES (5, 5, 4, 80, '2024-01-08');
INSERT INTO grades VALUES (6, 7, 11, 95, '2024-02-27');
INSERT INTO grades VALUES (7, 8, 10, 100, '2024-11-17');
INSERT INTO grades VALUES (8, 10, 4, 70, '2025-07-01');
INSERT INTO grades VALUES (9, 10, 6, 75, '2025-03-22');
INSERT INTO grades VALUES (10, 11, 2, 100, '2025-02-17');
INSERT INTO grades VALUES (11, 9, 9, 100, '2024-07-28');
INSERT INTO grades VALUES (12, 8, 1, 90, '2025-05-24');
INSERT INTO grades VALUES (13, 1, 6, 65, '2025-04-24');
INSERT INTO grades VALUES (14, 11, 11, 65, '2025-03-02');
INSERT INTO grades VALUES (15, 6, 9, 85, '2024-11-15');
INSERT INTO grades VALUES (16, 12, 8, 70, '2024-02-23');
INSERT INTO grades VALUES (17, 8, 1, 80, '2024-01-26');
INSERT INTO grades VALUES (18, 4, 1, 85, '2025-09-13');
INSERT INTO grades VALUES (19, 9, 8, 80, '2024-11-07');
INSERT INTO grades VALUES (20, 5, 6, 60, '2025-05-04');
