-- Variant 1. Library
-- State of the database BEFORE Practice 4: exactly what Practice 1
-- should have produced -- only dimension table 1 ("books"), without
-- dimension table 2 or the fact table.
-- Idempotent script: DROP TABLE IF EXISTS before CREATE TABLE, so it
-- is safe to run both on an empty database and on an existing one.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS books;

CREATE TABLE books (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT,
    publication_year INTEGER,
    genre TEXT,
    copies_count INTEGER NOT NULL DEFAULT 1
);

INSERT INTO books (title, author, publication_year, genre, copies_count) VALUES
    ('Кобзар', 'Тарас Шевченко', 1840, 'поезія', 3),
    ('Тигролови', 'Іван Багряний', 1944, 'пригоди', 2),
    ('Захар Беркут', 'Іван Франко', 1883, 'історична проза', 4),
    ('Земля', 'Ольга Кобилянська', 1902, 'проза', 2),
    ('Місто', 'Валер''ян Підмогильний', 1928, 'роман', 2),
    ('Собор', 'Олесь Гончар', 1968, 'роман', 3);
