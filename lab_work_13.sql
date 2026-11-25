-- Практична робота 13. Варіант 3 — база даних кінотеатру

-- Завдання 1. printf() з двома знаками після крапки
SELECT id, price, printf('%.2f грн', price) AS formatted_price
FROM tickets ORDER BY id;
-- Результати: (1,180.0,'180.00 грн'); (2,200.0,'200.00 грн');
-- (3,170.0,'170.00 грн'); (4,150.0,'150.00 грн'); (5,190.0,'190.00 грн')

-- Завдання 2. printf() з мінімальною шириною поля 8 символів
SELECT id, price, printf('%8.2f грн', price) AS formatted_price
FROM tickets ORDER BY id;
-- Результати: (1,180.0,'  180.00 грн'); (2,200.0,'  200.00 грн');
-- (3,170.0,'  170.00 грн'); (4,150.0,'  150.00 грн'); (5,190.0,'  190.00 грн')

-- Завдання 3. Дата через 30 днів після покупки
SELECT id, purchase_date, date(purchase_date, '+30 days') AS date_after_30_days
FROM tickets ORDER BY id;
-- (1,'2026-09-28','2026-10-28'); (2,'2026-09-29','2026-10-29');
-- (3,'2026-09-29','2026-10-29'); (4,'2026-09-30','2026-10-30');
-- (5,'2026-09-30','2026-10-30')

-- Завдання 4. Кількість квитків за роком покупки
SELECT strftime('%Y', purchase_date) AS purchase_year, COUNT(*) AS tickets_count
FROM tickets GROUP BY purchase_year ORDER BY purchase_year;
-- Результат: ('2026', 5)

-- Завдання 5. Некоректна дата
SELECT strftime('%Y', 'not-a-date') AS extracted_year,
       date('not-a-date') AS converted_date;
-- Результат у Python: (None, None), тобто обидві функції повернули SQL NULL.

-- Контрольні питання:
-- printf() змінює лише вигляд результату запиту, а не дані в таблиці.
-- strftime('%Y', ...) повертає текст року.
-- Для CHECK слід явно перевіряти допустимість дати та NULL; саме перетворення
-- некоректного рядка повертає NULL і не є достатньою перевіркою.
