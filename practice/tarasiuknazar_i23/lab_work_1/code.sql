CREATE TABLE cars (
    id INTEGER PRIMARY KEY,
    brand TEXT,
    model TEXT,
    year INTEGER,
    price REAL,
    status TEXT
);

INSERT INTO cars (brand, model, year, price, status) VALUES
('Toyota', 'Camry', 2022, 28500.00, 'доступний'),
('BMW', 'X5', 2021, 52000.00, 'проданий'),
('Skoda', 'Octavia', 2023, 24500.00, 'доступний'),
('Volkswagen', 'Golf', 2020, 18900.00, 'заброньований'),
('Audi', 'A6', 2022, 43000.00, 'доступний'),
('Renault', 'Megane', 2019, 14500.00, 'проданий');