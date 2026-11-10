-- Variant 6. Hotel
-- State of the database BEFORE Practice 4: only dimension table 1
-- ("rooms"), as Practice 1 should have produced.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS rooms;

CREATE TABLE rooms (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL,
    price_per_night REAL NOT NULL,
    capacity INTEGER,
    status TEXT NOT NULL DEFAULT 'вільний'
);

INSERT INTO rooms (type, price_per_night, capacity, status) VALUES
    ('Стандарт', 1200, 2, 'вільний'),
    ('Стандарт', 1200, 2, 'зайнятий'),
    ('Комфорт', 1800, 2, 'вільний'),
    ('Люкс', 3200, 4, 'вільний'),
    ('Сімейний', 2500, 4, 'зайнятий'),
    ('Економ', 800, 1, 'вільний');
