-- Завдання 1: GROUP BY по одній колонці
SELECT room_id, COUNT(*) AS кількість_бронювань
FROM bookings
GROUP BY room_id;

-- Завдання 2: зрозуміла версія через JOIN + GROUP BY
SELECT rooms.type, COUNT(bookings.id) AS кількість_бронювань
FROM rooms
LEFT JOIN bookings ON bookings.room_id = rooms.id
GROUP BY rooms.id;

-- Завдання 3: кілька агрегатних функцій в одній групі
SELECT rooms.type, 
       COUNT(bookings.id) AS кількість_бронювань,
       AVG(rooms.price_per_night) AS середня_ціна
FROM rooms
LEFT JOIN bookings ON bookings.room_id = rooms.id
GROUP BY rooms.id;

-- Завдання 4: GROUP BY за кількома колонками
SELECT rooms.type, rooms.status, COUNT(*) AS кількість
FROM rooms
GROUP BY rooms.type, rooms.status;

SELECT COUNT(DISTINCT type) FROM rooms;
SELECT COUNT(DISTINCT status) FROM rooms;

-- Завдання 5: пастка "колонка поза GROUP BY"
SELECT rooms.type, guests.last_name, COUNT(*) AS кількість
FROM bookings
JOIN rooms ON bookings.room_id = rooms.id
JOIN guests ON bookings.guest_id = guests.id
GROUP BY rooms.type;
-- Виконано двічі - значення guests.last_name непередбачуване
