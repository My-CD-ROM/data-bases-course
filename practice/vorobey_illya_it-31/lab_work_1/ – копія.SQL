SELECT * FROM cars;
INSERT INTO cars (brand, model, year, price, status) VALUES
    ('Toyota', 'Camry', 2022, 28500.00, 'продано'),
    ('BMW', 'X5', 2023, 72000.00, 'у продажу'),
    ('Volkswagen', 'Passat', 2021, 24500.00, 'у продажу'),
    ('Audi', 'A6', 2022, 51000.00, 'заброньовано'),
    ('Skoda', 'Octavia', 2023, 23000.00, 'у продажу'),
    ('Mercedes-Benz', 'C-Class', 2024, 63000.00, 'у продажу');
SELECT * FROM cars;
PRAGMA table_info(cars);
DELETE FROM cars
WHERE id > 6;
SELECT * FROM cars;