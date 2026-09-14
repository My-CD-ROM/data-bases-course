CREATE TABLE rooms (
    id              INTEGER PRIMARY KEY,
    type            TEXT NOT NULL,
    price_per_night REAL NOT NULL,
    capacity        INTEGER NOT NULL,
    status          TEXT NOT NULL
);

INSERT INTO rooms (type, price_per_night, capacity, status) VALUES
    ('стандарт', 1200.50, 2, 'вільна'),
    ('напівлюкс', 2200.00, 2, 'зайнята'),
    ('люкс', 4500.00, 4, 'вільна'),
    ('одинарний', 850.00, 1, 'вільна'),
    ('сімейний', 3100.00, 3, 'зайнята'),
    ('преміум', 8900.00, 2, 'вільна');
    
SELECT * FROM rooms;
