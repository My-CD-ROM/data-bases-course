-- Variant 5. Car dealership
-- State of the database BEFORE Practice 4: only dimension table 1
-- ("cars"), as Practice 1 should have produced.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS cars;

CREATE TABLE cars (
    id INTEGER PRIMARY KEY,
    brand TEXT NOT NULL,
    model TEXT NOT NULL,
    year INTEGER,
    price REAL,
    status TEXT NOT NULL DEFAULT 'в наявності'
);

INSERT INTO cars (brand, model, year, price, status) VALUES
    ('Toyota', 'Corolla', 2022, 720000, 'в наявності'),
    ('Volkswagen', 'Golf', 2021, 650000, 'продано'),
    ('Skoda', 'Octavia', 2023, 780000, 'в наявності'),
    ('Renault', 'Duster', 2020, 580000, 'в наявності'),
    ('Hyundai', 'Tucson', 2022, 950000, 'зарезервовано'),
    ('Ford', 'Focus', 2019, 490000, 'продано');
