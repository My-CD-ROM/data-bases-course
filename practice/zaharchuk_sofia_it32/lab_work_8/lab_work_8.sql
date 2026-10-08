-- Завдання 1: COUNT(*) проти COUNT(колонка)
-- Спершу послаблено NOT NULL на check_out_date (перестворення таблиці),
-- щоб продемонструвати різницю:
ALTER TABLE bookings RENAME TO bookings_old;
CREATE TABLE bookings (
    id              INTEGER PRIMARY KEY,
    room_id         INTEGER NOT NULL,
    guest_id        INTEGER NOT NULL,
    check_in_date   TEXT NOT NULL,
    check_out_date  TEXT,
    FOREIGN KEY (room_id)  REFERENCES rooms (id)  ON DELETE RESTRICT,
    FOREIGN KEY (guest_id) REFERENCES guests (id) ON DELETE CASCADE
);
INSERT INTO bookings SELECT * FROM bookings_old;
DROP TABLE bookings_old;

PRAGMA foreign_keys = ON;
INSERT INTO bookings (room_id, guest_id, check_in_date, check_out_date) VALUES (3, 5, '2026-09-28', NULL);

SELECT COUNT(*) FROM bookings;
-- Результат: 11

SELECT COUNT(check_out_date) FROM bookings;
-- Результат: 10 (NULL-рядок пропущено)

-- Завдання 2: SUM і AVG
SELECT SUM(price_per_night) AS сума_цін, AVG(price_per_night) AS середня_ціна
FROM rooms;

-- Завдання 3: MIN/MAX на датовій колонці
SELECT MIN(check_in_date) AS найраніша_дата, MAX(check_in_date) AS найпізніша_дата
FROM bookings;

-- Завдання 4: кілька агрегатних функцій одночасно
SELECT
    COUNT(*)              AS всього_бронювань,
    SUM(rooms.price_per_night) AS сумарна_вартість,
    AVG(rooms.price_per_night) AS середня_ціна,
    MIN(bookings.check_in_date) AS найраніший_заїзд,
    MAX(bookings.check_in_date) AS найпізніший_заїзд
FROM bookings
JOIN rooms ON bookings.room_id = rooms.id;

-- Завдання 5: агрегат + WHERE
SELECT COUNT(*) AS кількість_бронювань_люкс
FROM bookings
JOIN rooms ON bookings.room_id = rooms.id
WHERE rooms.type = 'люкс';

SELECT COUNT(*) FROM bookings;
-- Порівняння: кількість_бронювань_люкс менша за загальну кількість
