-- Завдання 1
SELECT room_id, COUNT(*) AS кількість
FROM bookings
GROUP BY room_id
HAVING COUNT(*) > 1;

-- Завдання 2
SELECT guests.last_name, AVG(rooms.price_per_night) AS середня_ціна
FROM bookings
JOIN rooms ON bookings.room_id = rooms.id
JOIN guests ON bookings.guest_id = guests.id
GROUP BY guests.id
HAVING AVG(rooms.price_per_night) > 1500;

-- Завдання 3
SELECT rooms.type, COUNT(bookings.id) AS кількість
FROM rooms
JOIN bookings ON bookings.room_id = rooms.id
WHERE rooms.capacity >= 2
GROUP BY rooms.id
HAVING COUNT(bookings.id) >= 2;

-- Завдання 4 (навмисна помилка)
-- SELECT room_id, COUNT(*) FROM bookings WHERE COUNT(*) > 1 GROUP BY room_id;
-- Текст помилки SQLite: misuse of aggregate: COUNT()

-- Завдання 5
SELECT rooms.type, COUNT(bookings.id) AS кількість
FROM rooms
LEFT JOIN bookings ON bookings.room_id = rooms.id
GROUP BY rooms.id
HAVING COUNT(bookings.id) < 2;
