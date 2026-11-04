-- Завдання 1
SELECT type, price_per_night, printf('%.2f грн', price_per_night) AS ціна
FROM rooms;

-- Завдання 2
SELECT type, printf('[%10.2f]', price_per_night) AS вирівняна_ціна, printf('[%03d]', id) AS номер
FROM rooms;

-- Завдання 3
SELECT id, check_out_date, date(check_out_date, '+3 days') AS продовження_до
FROM bookings;

-- Завдання 4
SELECT strftime('%Y-%m', check_in_date) AS місяць, COUNT(*) AS кількість
FROM bookings
GROUP BY місяць
ORDER BY місяць;

-- Завдання 5
SELECT strftime('%Y', 'not-a-date') AS a, date('15.09.2026') AS b, date('2026-02-30') AS c;
-- a = NULL, b = NULL, c = 2026-03-02 (помилки немає)
