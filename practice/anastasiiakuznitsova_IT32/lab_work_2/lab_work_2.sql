-- Завдання 1
SELECT last_name, first_name, group_name, admission_year
FROM students;

-- Завдання 2
SELECT last_name, first_name, admission_year
FROM students
WHERE admission_year >= 2025;

-- Завдання 3
SELECT last_name, first_name, group_name
FROM students
LIMIT 3;

-- Завдання 4
SELECT last_name, first_name, note
FROM students
WHERE note IS NULL;

SELECT last_name, first_name, note
FROM students
WHERE note IS NOT NULL;

-- Завдання 5
SELECT last_name, first_name, group_name, admission_year
FROM students
WHERE group_name = 'IT-32' AND admission_year >= 2025;
