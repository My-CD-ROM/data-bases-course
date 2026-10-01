-- Variant 10. Transport company
-- State of the database BEFORE Practice 4: only dimension table 1
-- ("drivers"), as Practice 1 should have produced.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS drivers;

CREATE TABLE drivers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    experience_years INTEGER,
    license_category TEXT
);

INSERT INTO drivers (last_name, first_name, experience_years, license_category) VALUES
    ('Кравець', 'Петро', 12, 'CE'),
    ('Захарчук', 'Ігор', 5, 'C'),
    ('Романюк', 'Василь', 20, 'CE'),
    ('Панченко', 'Олег', 8, 'D'),
    ('Гаврилюк', 'Микола', 3, 'B'),
    ('Сидоренко', 'Тарас', 15, 'CE');
