PRAGMA foreign_keys = ON;

--Завдання1
CREATE TABLE courses (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    credits INTEGER NOT NULL,
    semester INTEGER NOT NULL
);

--Завдання2
CREATE TABLE grades (
    id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    grade INTEGER NOT NULL,
    grade_date TEXT NOT NULL,
    FOREIGN KEY (student_id)
        REFERENCES students(id)
        ON DELETE RESTRICT,
    FOREIGN KEY (course_id)
        REFERENCES courses(id)
        ON DELETE CASCADE
);

--Завдання3
INSERT INTO courses (title, credits, semester) VALUES
('Бази даних', 5, 3),
('Програмування', 6, 2),
('Вища математика', 4, 1),
('Алгоритми та структури даних', 5, 3),
('Веб-розробка', 4, 4);

INSERT INTO grades (student_id, course_id, grade, grade_date) VALUES
(1, 1, 90, '2026-09-01'),
(1, 2, 85, '2026-09-02'),
(2, 3, 75, '2026-09-01'),
(3, 1, 95, '2026-09-03'),
(4, 4, 88, '2026-09-04'),
(5, 2, 60, '2026-09-02'),
(6, 5, 92, '2026-09-05'),
(2, 4, 78, '2026-09-04'),
(3, 5, 82, '2026-09-05');
