CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    group_name TEXT NOT NULL,
    admission_year INTEGER NOT NULL
);

INSERT INTO students (last_name, first_name, group_name, admission_year) VALUES
('Wilson', 'James', 'IT-32', 2026),
('Carter', 'Emily', 'IT-22', 2025),
('Brown', 'Oliver', 'IT-12', 2024),
('Taylor', 'Sophie', 'IT-32', 2026),
('Miller', 'Daniel', 'IT-22', 2025),
('Anderson', 'Chloe', 'IT-12', 2024);