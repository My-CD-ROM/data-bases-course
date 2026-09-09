.open hotel.db
CREATE TABLE rooms( id INTEGER PRIMARY KEY, type TEXT, status TEXT, price_per_night REAL, capacity INTEGER );
INSERT INTO rooms (type, status, price_per_night, capacity)
VALUES
    ('Люкс', 'Вільно', "1200", "2"),
    ('Люкс', 'Заброньовано', "950", "1"),
    ('Стандарт', 'Заброньовано', "1200", "3"),
    ('Люкс', 'Заброньовано', "1200", "2"),
    ('Стандарт', 'Вільно', "500", "1");
SELECT * FROM rooms;