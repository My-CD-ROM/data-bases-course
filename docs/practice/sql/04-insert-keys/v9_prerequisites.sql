-- Variant 9. University
-- State of the database BEFORE Practice 4: only dimension table 1
-- ("students"), as Practice 1 should have produced.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS students;

CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    group_name TEXT,
    admission_year INTEGER
);

INSERT INTO students (last_name, first_name, group_name, admission_year) VALUES
    ('Коваленко', 'Олена', 'ІС-21', 2021),
    ('Бондаренко', 'Максим', 'ІС-21', 2021),
    ('Шевчук', 'Ірина', 'ІС-22', 2022),
    ('Мельник', 'Андрій', 'ІС-22', 2022),
    ('Ткаченко', 'Софія', 'ІС-23', 2023),
    ('Гнатюк', 'Дмитро', 'ІС-23', 2023);
