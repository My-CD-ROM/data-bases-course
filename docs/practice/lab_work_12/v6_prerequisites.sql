-- Variant 6. Hotel
-- State of the database BEFORE Practice 4: only dimension table 1
-- ("rooms"), as Practice 1 should have produced.

PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS guests;

CREATE TABLE rooms (
    id INTEGER PRIMARY KEY,
    type TEXT NOT NULL,
    price_per_night REAL NOT NULL CHECK(price_per_night > 0),
    capacity INTEGER NOT NULL,
    status TEXT NOT NULL DEFAULT 'вільний'
);

INSERT INTO rooms (type, price_per_night, capacity, status) VALUES
    ('Стандарт', 1200, 2, 'вільний'),
    ('Стандарт', 1200, 2, 'зайнятий'),
    ('Комфорт', 1800, 2, 'вільний'),
    ('Люкс', 3200, 4, 'вільний'),
    ('Сімейний', 2500, 4, 'зайнятий'),
    ('Економ', 800, 1, 'вільний');

CREATE TABLE guests(
    id integer primary key,
    last_name string not null,
    first_name string not null,
    email string not null DEFAULT"Гість не вказав ел. адресу =(",
    phone string not null UNIQUE
);
INSERT INTO guests (last_name, first_name, email, phone) VALUES
('Шевченко', 'Олександр', 'shevchenko@gmail.com', '+380671234567'),
('Ковальчук', 'Марія', 'kovalchuk@gmail.com', '+380931234568'),
('Мельник', 'Андрій', 'melnyk@gmail.com', '+380501234569'),
('Бондаренко', 'Олена', 'bondarenko@gmail.com', '+380631234570'),
('Ткаченко', 'Дмитро', 'tkachenko@gmail.com', '+380971234571'),
('Романюк', 'Ірина', 'romaniuk@gmail.com', '+380661234572');

CREATE TABLE bookings(
    id INTEGER primary key,
    room_id INTEGER not null,
    guest_id INTEGER not null,
    check_in_date TEXT not null,
    check_out_date TEXT,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE RESTRICT,
    FOREIGN KEY (guest_id) REFERENCES guests(id) ON DELETE RESTRICT
);

INSERT INTO bookings (room_id, guest_id, check_in_date, check_out_date) VALUES
(1, 1, '2026-09-01', '2026-09-03'),
(3, 2, '2026-09-02', '2026-09-05'),
(4, 3, '2026-09-05', '2026-09-10'),
(2, 4, '2026-09-07', '2026-09-09'),
(5, 5, '2026-09-10', '2026-09-14'),
(6, 6, '2026-09-12', '2026-09-13'),
(1, 3, '2026-09-15', '2026-09-18'),
(3, 1, '2026-09-18', '2026-09-21'),
(4, 6, '2026-09-20', '2026-09-25'),
(5, 2, '2026-09-22', '2026-09-27');
drop table guests_old

--UPDATE rooms SET price_per_night = -1 WHERE id = 2;

--INSERT INTO rooms (type, price_per_night, status)
--VALUES ('Тест', 1000, 'вільний');

--INSERT INTO guests (last_name, first_name, email, phone)
--VALUES ('Тест', 'Гість', 'test@gmail.com', '+380671234567');

--практична 6
UPDATE rooms SET capacity = 3 WHERE id = 1;

UPDATE bookings SET room_id = 2 WHERE id = 1;
DELETE from bookings WHERE id=1;

DELETE from rooms where id = 3;

--практична 7
SELECT rooms.capacity, rooms.status
FROM bookings
INNER JOIN rooms on bookings.room_id = rooms.id
WHERE rooms.status="вільний";
--------------
SELECT rooms.capacity, guests.phone
FROM bookings
INNER JOIN rooms on bookings.room_id = rooms.id
INNER JOIN guests on bookings.guest_id = guests.id
WHERE rooms.status="зайнятий";
--------------
INSERT INTO rooms(type, price_per_night, capacity, status)
VALUES("практична7", 1999,9 ,"тест");

SELECT rooms.capacity, bookings.room_id
FROM rooms
LEFT join bookings on rooms.id=bookings.room_id
WHERE bookings.id IS NULL;
--------------
SELECT COUNT(*) FROM rooms;
--результат: 7
SELECT COUNT(*) FROM guests;
--результат: 6
SELECT COUNT(*) FROM guests, rooms;
--результат: 42



--------------------------
--------ПРАКТИЧНА 8-------
--------------------------
SELECT COUNT(*) FROM bookings;
--результат: 10
SELECT COUNt(check_out_date) from bookings;
--результат: 10
DROP table bookings
;
CREATE TABLE bookings(
id INTEGER primary key,
room_id INTEGER not null,
guest_id INTEGER not null,
check_in_date TEXT not null,
check_out_date TEXT,
FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE RESTRICT,
FOREIGN KEY (guest_id) REFERENCES guests(id) ON DELETE RESTRICT
;

INSERT INTO bookings (room_id, guest_id, check_in_date, check_out_date) VALUES
(1, 1, '2026-09-01', '2026-09-03'),
(3, 2, '2026-09-02', '2026-09-05'),
(4, 3, '2026-09-05', '2026-09-10'),
(2, 4, '2026-09-07', '2026-09-09'),
(5, 5, '2026-09-10', '2026-09-14'),
(6, 6, '2026-09-12', '2026-09-13'),
(1, 3, '2026-09-15', '2026-09-18'),
(3, 1, '2026-09-18', '2026-09-21'),
(4, 6, '2026-09-20', '2026-09-25'),
(5, 2, '2026-09-22', '2026-09-27');
UPDATE bookings SET check_out_date = NULL WHERE id=2;

SELECT COUNT(*) FROM bookings;
--результат: 10
SELECT COUNt(check_out_date) from bookings;
--результат: 9

---------------------
SELECT
    avg(price_per_night),
    sum(price_per_night)
FROM rooms;
--результат: 1628.42857142857|11399.0
------------------------
SELECT min(check_in_date) from bookings;
SELECT max(last_name) from guests;
------------------------
SELECT
    max(check_out_date) AS "Остання дата виселення",
    COUNT(*) AS "Всього бронювань",
    sum(guest_id) AS "Сума id гостей"
from bookings;
--------------------------
SELECT COUNT(*) from rooms where capacity>2;



--------------------------
--------ПРАКТИЧНА  9 -----
--------------------------
--ЗАВДАННЯ 1:
SELECT room_id, COUNT(*) AS bookings_count
FROM bookings
GROUP BY room_id;
--ЗАВДАННЯ 2:
SELECT rooms.type, COUNT(*) AS bookings_count
FROM bookings
INNER JOIN rooms ON bookings.room_id = rooms.id
GROUP BY rooms.id;
--ЗАВДАННЯ 3:
SELECT rooms.type,
COUNT(*) AS bookings_count,
max(guest_id)
FROM bookings
INNER JOIN rooms ON bookings.room_id = rooms.id
GROUP BY rooms.id;
--ЗАВДАННЯ 4:
SELECT room_id, guest_id
FROM bookings
GROUP BY room_id, guest_id;
SELECT COUNT(DISTINCT room_id) FROM bookings;
SELECT COUNT(DISTINCT guest_id) FROM bookings;
--ЗАВДАННЯ 5:
SELECT guest_id
FROM bookings
GROUP BY room_id;


--------------------------
--------ПРАКТИЧНА  10 -----
--------------------------
--ЗАВДАННЯ 1:
SELECT room_id, COUNT(*) AS bookings_count
FROM bookings
GROUP by room_id
HAVING COUNT(*)>1;
--ЗАВДАННЯ 2:
SELECT type, MAX(price_per_night) AS max_price
FROM rooms
GROUP BY type
HAVING MAX(price_per_night) < 1000.1;
--ЗАВДАННЯ 3:
SELECT type
FROM rooms
WHERE status = "вільний"
GROUP BY type
HAVING MAX(price_per_night) < 1500;
--ЗАВДАННЯ 4:
--SELECT room_id, COUNT(*) AS bookings_count
--FROM bookings
--WHERE COUNT(*)>1
--GROUP by room_id;

--Parse error: misuse of aggregate


--ЗАВДАННЯ 5:
SELECT rooms.id, rooms.capacity, COUNT(bookings.id) AS bookings_count
FROM rooms
LEFT JOIN bookings ON rooms.id = bookings.room_id
GROUP BY rooms.id
HAVING COUNT(bookings.id) < 2;

--------------------------
------ ПРАКТИЧНА 11 ------
--------------------------
CREATE table repairs (
    id INTEGER PRIMARY KEY,
    room_id INTEGER not null,
    category TEXT NOT NULL,
    cost INTEGER not null CHECK(cost>0),
    date DATE not null,
    FOREIGN KEY (room_id) REFERENCES rooms(id)
);
INSERT INTO repairs(room_id, category, cost, date) VALUES
(1, 'Сантехніка', 1500, '2026-09-05'),
(1, 'Електрика', 2300, '2026-09-18'),
(2, 'Меблі', 4200, '2026-09-07'),
(2, 'Двері', 1100, '2026-09-22'),
(2, 'Сантехніка', 800, '2026-10-03'),
(3, 'Кондиціонер', 3500, '2026-09-12'),
(3, 'Електрика', 1900, '2026-10-01'),
(4, 'Сантехніка', 1250, '2026-09-09'),
(4, 'Меблі', 5700, '2026-09-25'),
(4, 'Вікна', 3100, '2026-10-05'),
(5, 'Двері', 1600, '2026-09-14'),
(5, 'Кондиціонер', 2800, '2026-10-08'),
(6, 'Електрика', 950, '2026-09-20'),
(6, 'Сантехніка', 1750, '2026-10-02'),
(7, 'Меблі', 3900, '2026-09-11'),
(7, 'Двері', 2200, '2026-10-06'),
(7, 'Кондиціонер', 4500, '2026-10-12'),
(1, 'Фарбування', 1300, '2026-10-15'),
(3, 'Заміна замка', 700, '2026-10-18'),
(5, 'Ремонт підлоги', 2600, '2026-10-20'),
(2, 'Фарбування', 1800, '2026-10-22'),
(6, 'Заміна сантехніки', 3200, '2026-10-25'),
(4, 'Ремонт стелі', 2100, '2026-10-27'),
(7, 'Заміна освітлення', 1400, '2026-10-29');


SELECT repairs.room_id, rooms.type, SUM(repairs.cost)
FROM repairs
JOIN rooms ON rooms.id = repairs.room_id
GROUP BY room_id;

SELECT repairs.room_id, rooms.type, SUM(repairs.cost)
FROM repairs
JOIN rooms ON rooms.id = repairs.room_id
GROUP BY room_id
HAVING SUM(repairs.cost)>6000;

SELECT repairs.room_id, rooms.type, SUM(repairs.cost)
FROM repairs
JOIN rooms ON rooms.id = repairs.room_id
WHERE repairs.date >= "2026-10-01"
GROUP BY room_id
HAVING SUM(repairs.cost)>6000;


INSERT INTO rooms (type, price_per_night, capacity, status)
VALUES ('Люкс', 4000, 4, 'вільний');
INSERT INTO repairs (room_id, category, cost, date) VALUES
(8, 'Сантехніка', 2500, '2026-10-10'),
(8, 'Електрика', 3000, '2026-10-15');

SELECT rooms.id, rooms.type, SUM(repairs.cost) AS total_cost
FROM rooms
JOIN repairs ON rooms.id = repairs.room_id
GROUP BY rooms.id;
INSERT INTO rooms (type, price_per_night, capacity, status)
VALUES ('Президентський', 5000, 4, 'вільний');

SELECT rooms.id, rooms.type, SUM(repairs.cost) AS total_cost
FROM rooms
JOIN repairs ON rooms.id = repairs.room_id
WHERE repairs.date > '2026-10-01'
GROUP BY rooms.id
HAVING SUM(repairs.cost) > 6000;

SELECT rooms.id, rooms.type, SUM(repairs.cost) AS total_cost
FROM rooms
LEFT JOIN repairs ON rooms.id = repairs.room_id
WHERE repairs.date > '2026-10-01'
GROUP BY rooms.id
HAVING SUM(repairs.cost) > 6000;


--------------------------
------ ПРАКТИЧНА 12 ------
--------------------------
--1)
SELECT SUM(cost), room_id
FROM repairs
GROUP BY room_id
ORDER BY cost DESC;
--2)
SELECT cost, room_id, date
FROM repairs
ORDER BY cost DESC, date ASC;

SELECT cost, room_id, date
FROM repairs
ORDER BY date DESC, cost ASC;
--3)
SELECT cost, room_id
FROM repairs
ORDER BY cost DESC LIMIT 3;
--4)
SELECT DISTINCT category
FROM repairs;

SELECT category, SUM(cost)
FROM repairs
WHERE category IN("Меблі", "Двері", "Вікна")
GROUP BY category;
--5)
SELECT DISTINCT category
FROM repairs
WHERE category LIKE "С%";

SELECT DISTINCT category
FROM repairs
WHERE category LIKE "с%";

