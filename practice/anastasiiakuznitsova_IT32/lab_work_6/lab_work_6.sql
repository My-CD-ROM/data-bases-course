PRAGMA foreign_keys = ON;

UPDATE grades
SET grade = 95
WHERE id = 1;

UPDATE courses
SET semester = 2
WHERE id = 3;

DELETE FROM grades
WHERE id = 9;

DELETE FROM courses
WHERE id = 1;