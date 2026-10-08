-- Variant 7. Gym
-- State of the database BEFORE Practice 4: only dimension table 1
-- ("memberships"), as Practice 1 should have produced.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS memberships;

CREATE TABLE memberships (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL,
    duration_days INTEGER NOT NULL,
    price REAL NOT NULL
);

INSERT INTO memberships (type, duration_days, price) VALUES
    ('Разовий', 1, 150),
    ('Тижневий', 7, 500),
    ('Місячний', 30, 1200),
    ('Квартальний', 90, 3000),
    ('Річний', 365, 9500),
    ('Студентський місячний', 30, 800);
