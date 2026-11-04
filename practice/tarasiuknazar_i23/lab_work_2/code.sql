TASK #1:
    SELECT brand, model, year FROM cars
TASK #2:
    SELECT * FROM cars WHERE year > 2020
TASK #3:
    SELECT * FROM cars LIMIT 3
TASK #4:
    INSERT INTO cars (brand, model, year, price, status) VALUES ("mercedes",  NULL, 2027, 60000, "заброньований")
    SELECT * FROM cars WHERE model IS NULL
    SELECT * FROM cars WHERE model IS NOT NULL
    `NULL` означає відсутнє або невідоме значення, тому його не можна коректно порівнювати за допомогою `= NULL`. Для перевірки на наявність або відсутність `NULL` використовують оператори `IS NULL` та `IS NOT NULL`.
TASK #5:
    SELECT * FROM cars WHERE model IS NOT NULL OR year > 2020

КОНТРОЛЬНІ ЗАПИТАННЯ:
    - Бо не можна порівнювати NULL з NULL (неможливо порівняти нічого з нічим)
    - WHERE фільтрує всі рядки за умовою а GROUP BY ... HAVING ... фільтрує групи рядків за умовою
    - Коли потрібні не всі стовпці таблиці, а лише деякі з них