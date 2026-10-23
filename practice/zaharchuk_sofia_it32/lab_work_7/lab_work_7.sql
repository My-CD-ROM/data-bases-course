-- Завдання 1: INNER JOIN факт + вимір 1 (bookings + rooms)
SELECT rooms.type, bookings.check_in_date, bookings.check_out_date
FROM bookings
JOIN rooms ON bookings.room_id = rooms.id
ORDER BY bookings.check_in_date;
-- Результат: 10 рядків, усі бронювання з типом номера замість room_id

-- Завдання 2: INNER JOIN усіх трьох таблиць
SELECT rooms.type, guests.last_name, guests.first_name, bookings.check_in_date, bookings.check_out_date
FROM bookings
JOIN rooms ON bookings.room_id = rooms.id
JOIN guests ON bookings.guest_id = guests.id
ORDER BY bookings.check_in_date;
-- Результат: 10 рядків, тип номера + прізвище/ім'я гостя + дати, без жодного id

-- Завдання 3: LEFT JOIN - номери без жодного бронювання
SELECT rooms.type, rooms.status
FROM rooms
LEFT JOIN bookings ON bookings.room_id = rooms.id
WHERE bookings.id IS NULL;
-- Результат: пентхаус|вільний (номер додавався раніше в Практиці 5,
-- жодного бронювання на нього ще не було - новий рядок додавати не знадобилось)

-- Завдання 4: свідома пастка CROSS JOIN
SELECT COUNT(*) FROM rooms, guests;
-- Результат: 42

SELECT COUNT(*) FROM rooms;
-- Результат: 7

SELECT COUNT(*) FROM guests;
-- Результат: 6
-- 42 = 7 * 6 (добуток, а не сума 7+6=13) - підтверджено на власних даних
