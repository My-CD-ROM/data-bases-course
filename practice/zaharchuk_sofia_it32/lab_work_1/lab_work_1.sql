CREATE TABLE rooms (
    id                 INTEGER PRIMARY KEY,
    type               TEXT NOT NULL,
    price_per_night    REAL NOT NULL,
    capacity           INTEGER NOT NULL,
    status             TEXT NOT NULL
);

INSERT INTO rooms (type, price_per_night, capacity, status) VALUES
    ('одномісний', 850.0, 1, 'вільний'),
    ('двомісний', 1200.0, 2, 'зайнятий'),
    ('люкс', 2500.0, 2, 'вільний'),
    ('сімейний', 1800.0, 4, 'на прибиранні'),
    ('стандарт', 950.0, 2, 'зайнятий'),
    ('президентський', 4500.0, 3, 'вільний');

