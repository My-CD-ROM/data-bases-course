CREATE TABLE memberships (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL,
    duration_days INTEGER NOT NULL,
    price REAL NOT NULL
);
INSERT INTO memberships (type, duration_days, price) VALUES
    ('Разовий', 1, 150.00),
    ('Тижневий', 7, 500.00),
    ('Місячний', 30, 1200.00),
    ('Квартальний', 90, 3000.00),
    ('Піврічний', 180, 5200.00),
    ('Річний', 365, 9000.00);