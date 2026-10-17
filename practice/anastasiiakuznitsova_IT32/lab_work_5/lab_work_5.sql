PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS courses (
    id INTEGER PRIMARY KEY,
    title TEXT UNIQUE,
    credits INTEGER NOT NULL CHECK (credits > 0),
    semester INTEGER DEFAULT 1
);

INSERT INTO courses (title, credits, semester)
VALUES ('Бази даних', 5, 3);

INSERT INTO courses (title, credits, semester)
VALUES ('Програмування', 6, 2);

INSERT INTO courses (title, credits, semester)
VALUES ('Вища математика', 4, 1);

INSERT INTO courses (title, credits, semester)
VALUES ('Алгоритми та структури даних', 5, 3);

INSERT INTO courses (title, credits, semester)
VALUES ('Веб-розробка', 4, 4);

INSERT INTO courses (title, credits, semester)
VALUES ('Тест CHECK 2', 3, 1);

INSERT INTO courses (title, credits)
VALUES ('Тест DEFAULT', 4);

SELECT * FROM courses
WHERE title = 'Тест DEFAULT';

SELECT * FROM courses;