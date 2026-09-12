-- Variant 3. Cinema
-- State of the database BEFORE Practice 4: only dimension table 1
-- ("movies"), as Practice 1 should have produced.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS movies;

CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    genre TEXT,
    duration_min INTEGER,
    year INTEGER,
    age_rating INTEGER
);

INSERT INTO movies (title, genre, duration_min, year, age_rating) VALUES
    ('Тіні забутих предків', 'драма', 97, 1965, 12),
    ('Захар Беркут', 'бойовик', 115, 2019, 16),
    ('Мавка. Лісова пісня', 'анімація', 94, 2023, 6),
    ('Я, Ти, Він, Вона', 'комедія', 90, 2021, 16),
    ('Атлантида', 'драма', 108, 2019, 16),
    ('Памфір', 'драма', 106, 2022, 18);
