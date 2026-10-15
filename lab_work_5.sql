PRAGMA foreign_keys = ON;

CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    full_name TEXT,
    group_name TEXT,
    age INTEGER
);

CREATE TABLE subjects (
    id INTEGER PRIMARY KEY,
    name TEXT,
    hours INTEGER,
    status TEXT
);

INSERT INTO students VALUES
(1, 'Тарасюк Олександр', 'ІТ-32', 17),
(2, 'Іваненко Андрій', 'ІТ-32', 18),
(3, 'Петренко Максим', 'ІТ-31', 18);

INSERT INTO subjects VALUES
(1, 'Бази даних', 60, 'активний'),
(2, 'Програмування', 90, 'активний'),
(3, 'Вебтехнології', 75, 'активний');

ALTER TABLE students RENAME TO students_old;

CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    group_name TEXT,
    age INTEGER
);

INSERT INTO students
SELECT * FROM students_old;

DROP TABLE students_old;

ALTER TABLE subjects RENAME TO subjects_old;

CREATE TABLE subjects (
    id INTEGER PRIMARY KEY,
    name TEXT UNIQUE,
    hours INTEGER,
    status TEXT
);

INSERT INTO subjects
SELECT * FROM subjects_old;

DROP TABLE subjects_old;

ALTER TABLE subjects RENAME TO subjects_old;

CREATE TABLE subjects (
    id INTEGER PRIMARY KEY,
    name TEXT UNIQUE,
    hours INTEGER CHECK (hours > 0),
    status TEXT
);

INSERT INTO subjects
SELECT * FROM subjects_old;

DROP TABLE subjects_old;

ALTER TABLE subjects RENAME TO subjects_old;

CREATE TABLE subjects (
    id INTEGER PRIMARY KEY,
    name TEXT UNIQUE,
    hours INTEGER CHECK (hours > 0),
    status TEXT NOT NULL DEFAULT 'активний'
);

INSERT INTO subjects
SELECT * FROM subjects_old;

DROP TABLE subjects_old;

INSERT INTO subjects (name, hours)
VALUES ('Операційні системи', 60);

SELECT *
FROM subjects
WHERE name = 'Операційні системи';

UPDATE subjects
SET hours = -5
WHERE name = 'Операційні системи';