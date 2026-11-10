DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS guests;
DROP TABLE IF EXISTS rooms;
CREATE TABLE rooms (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL,
    price_per_night REAL,
    capacity INTEGER,
    status TEXT
);
CREATE TABLE guests (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT UNIQUE,
    phone TEXT
);
CREATE TABLE bookings (
    id INTEGER PRIMARY KEY,
    room_id INTEGER REFERENCES rooms(id),
    guest_id INTEGER REFERENCES guests(id),
    check_in_date TEXT NOT NULL,
    check_out_date TEXT
);
INSERT INTO rooms VALUES (1, 'стандарт', 1200.0, 2, 'вільна');
INSERT INTO rooms VALUES (2, 'стандарт', 1200.0, 2, 'зайнята');
INSERT INTO rooms VALUES (3, 'делюкс', 1900.0, 2, 'зайнята');
INSERT INTO rooms VALUES (4, 'делюкс', 1900.0, 2, 'зайнята');
INSERT INTO rooms VALUES (5, 'люкс', 2800.0, 3, 'зайнята');
INSERT INTO rooms VALUES (6, 'люкс', 2800.0, 3, 'вільна');
INSERT INTO rooms VALUES (7, 'стандарт', 1200.0, 2, 'зайнята');
INSERT INTO rooms VALUES (8, 'делюкс', 1900.0, 2, 'вільна');
INSERT INTO rooms VALUES (9, 'люкс', 2800.0, 3, 'вільна');
INSERT INTO rooms VALUES (10, 'стандарт', 1200.0, 2, 'зайнята');
INSERT INTO rooms VALUES (11, 'делюкс', 1900.0, 2, 'вільна');
INSERT INTO rooms VALUES (12, 'сюїт', 4200.0, 4, 'зайнята');
INSERT INTO guests VALUES (1, 'Коваль', 'Софія', 'софія.коваль1@example.com', '+380634000001');
INSERT INTO guests VALUES (2, 'Іванов', 'Дарина', 'дарина.іванов2@example.com', '+380634000002');
INSERT INTO guests VALUES (3, 'Литвин', 'Наталія', 'наталія.литвин3@example.com', '+380634000003');
INSERT INTO guests VALUES (4, 'Коваль', 'Максим', 'максим.коваль4@example.com', '+380634000004');
INSERT INTO guests VALUES (5, 'Кравець', 'Дарина', 'дарина.кравець5@example.com', '+380634000005');
INSERT INTO guests VALUES (6, 'Захарченко', 'Ігор', 'ігор.захарченко6@example.com', '+380634000006');
INSERT INTO guests VALUES (7, 'Литвин', 'Дарина', 'дарина.литвин7@example.com', '+380634000007');
INSERT INTO guests VALUES (8, 'Кравець', 'Софія', 'софія.кравець8@example.com', '+380634000008');
INSERT INTO guests VALUES (9, 'Литвин', 'Марія', 'марія.литвин9@example.com', '+380634000009');
INSERT INTO guests VALUES (10, 'Бондаренко', 'Тетяна', 'тетяна.бондаренко10@example.com', '+380634000010');
INSERT INTO guests VALUES (11, 'Бондаренко', 'Дарина', 'дарина.бондаренко11@example.com', '+380634000011');
INSERT INTO guests VALUES (12, 'Коваль', 'Марія', 'марія.коваль12@example.com', '+380634000012');
INSERT INTO bookings VALUES (1, 8, 3, '2025-01-02', '2024-05-12');
INSERT INTO bookings VALUES (2, 6, 7, '2024-04-17', '2024-03-06');
INSERT INTO bookings VALUES (3, 2, 10, '2025-10-22', NULL);
INSERT INTO bookings VALUES (4, 10, 3, '2024-08-21', NULL);
INSERT INTO bookings VALUES (5, 5, 11, '2024-08-10', '2024-02-15');
INSERT INTO bookings VALUES (6, 6, 10, '2025-11-14', '2025-05-07');
INSERT INTO bookings VALUES (7, 7, 8, '2024-04-13', '2025-12-10');
INSERT INTO bookings VALUES (8, 1, 11, '2025-05-01', '2024-10-24');
INSERT INTO bookings VALUES (9, 8, 5, '2024-10-26', '2024-10-09');
INSERT INTO bookings VALUES (10, 11, 12, '2024-11-04', '2024-05-26');
INSERT INTO bookings VALUES (11, 8, 1, '2025-12-05', NULL);
INSERT INTO bookings VALUES (12, 5, 6, '2025-03-07', NULL);
INSERT INTO bookings VALUES (13, 9, 6, '2025-03-09', '2025-05-24');
INSERT INTO bookings VALUES (14, 6, 2, '2025-02-05', '2024-11-24');
INSERT INTO bookings VALUES (15, 11, 7, '2025-02-26', '2025-09-04');
INSERT INTO bookings VALUES (16, 8, 6, '2025-10-13', '2025-02-22');
INSERT INTO bookings VALUES (17, 4, 8, '2024-10-18', '2024-11-03');
INSERT INTO bookings VALUES (18, 11, 8, '2025-11-14', NULL);
INSERT INTO bookings VALUES (19, 1, 1, '2025-08-04', NULL);
INSERT INTO bookings VALUES (20, 9, 3, '2025-08-12', '2025-10-24');
