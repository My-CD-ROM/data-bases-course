-- Практика 13. printf() і дати (варіант 2, інтернет-магазин одягу)

-- Завдання 1. printf() для числової колонки: сума кожного замовлення (quantity * price)
SELECT o.id,
       p.price,
       o.quantity,
       o.quantity * p.price AS raw_total,
       printf('%.2f грн', o.quantity * p.price) AS total
FROM orders o
JOIN products p ON p.id = o.product_id;
-- Результат (id, raw_total → total): 1: 598.0 → '598.00 грн' ; 2: 899.0 → '899.00 грн' ;
-- 3: 2499.0 → '2499.00 грн' ; 4: 1300.0 → '1300.00 грн' ; 5: 3798.0 → '3798.00 грн' ;
-- 6: 250.0 → '250.00 грн' ; 7: 897.0 → '897.00 грн' ; 8: 899.0 → '899.00 грн' ; 9: 250.0 → '250.00 грн'

-- Завдання 2. printf() з мінімальною шириною поля
SELECT id,
       price,
       printf('%8.2f', price) AS aligned_price,
       printf('%05d', id)     AS padded_id
FROM products;
-- Результат: (1, '  299.00', '00001') (2, '  899.00', '00002') (3, ' 2499.00', '00003')
-- (4, '  650.00', '00004') (5, ' 1899.00', '00005') (6, '  250.00', '00006')
-- (7, '  220.00', '00007') (8, '  299.00', '00008')

-- Завдання 3. Зсув дати: останній день повернення товару (+14 днів) і +1 місяць
SELECT id, order_date,
       date(order_date, '+14 days')  AS return_until,
       date(order_date, '+1 month')  AS plus_month
FROM orders;
-- Результат: 1: 2026-09-01 → 2026-09-15 / 2026-10-01 ... 9: 2026-09-09 → 2026-09-23 / 2026-10-09

-- Завдання 4. strftime() + GROUP BY
SELECT strftime('%Y', order_date) AS yr,
       strftime('%m', order_date) AS mon,
       COUNT(*) AS orders_count
FROM orders
GROUP BY yr, mon;
-- Результат: ('2026', '09', 9)   — усі замовлення в одному місяці
-- Для наочності те саме за відгуками (reviews), де дати різні:
SELECT strftime('%Y-%m', review_date) AS ym, COUNT(*) AS reviews_count
FROM reviews
GROUP BY ym;
-- Результат: ('2026-02', 2) ('2026-03', 1) ('2026-08', 3) ('2026-09', 6)

-- Завдання 5. Свідома помилка: некоректна дата
SELECT strftime('%Y', 'not-a-date') AS a,
       date('not-a-date')           AS b,
       strftime('%Y', '2026-13-45') AS c;
-- Результат: NULL | NULL | NULL   (помилки немає)
SELECT name, strftime('%Y', name) FROM products LIMIT 2;
-- Результат: ('Футболка базова', NULL) ('Джинси класичні', NULL)

-- Контрольне питання 2. strftime повертає текст
SELECT typeof(strftime('%Y', '2026-09-01')) AS t,
       strftime('%Y', '2026-09-01') = 2026   AS eq_int,
       strftime('%Y', '2026-09-01') = '2026' AS eq_text;
-- Результат: text | 0 | 1
