– Практична робота №7

– Завдання 1. INNER JOIN фактової таблиці з таблицею абонементів

SELECT membership_sales.id,
memberships.type
FROM membership_sales
JOIN memberships
ON membership_sales.membership_id = memberships.id
ORDER BY membership_sales.id;

– Результат:
– id  type
– 2   Тижневий
– 3   Місячний
– 5   Піврічний
– 6   Річний
– 7   Місячний
– 9   Місячний

– Завдання 2. INNER JOIN усіх трьох таблиць

SELECT membership_sales.id,
memberships.type,
clients.last_name,
membership_sales.purchase_date
FROM membership_sales
JOIN memberships
ON membership_sales.membership_id = memberships.id
JOIN clients
ON membership_sales.client_id = clients.id
ORDER BY membership_sales.id;

– Результат:
– id  type       last_name  purchase_date
– 2   Тижневий   Ковальчук  2026-09-02
– 3   Місячний   Мельник    2026-09-03
– 5   Піврічний  Бондар     2026-09-06
– 6   Річний     Ткаченко   2026-09-07
– 7   Місячний   Петренко   2026-09-08
– 9   Місячний   Ковальчук  2026-09-11

– Завдання 3. LEFT JOIN для пошуку абонементів без продажів

SELECT memberships.id,
memberships.type
FROM memberships
LEFT JOIN membership_sales
ON membership_sales.membership_id = memberships.id
WHERE membership_sales.id IS NULL;

– Результат:
– id  type
– 1   Разовий
– 4   Квартальний
– 7   Пробний
– 8   Тестовий
– 9   Стандартний

– Завдання 4. CROSS JOIN

SELECT COUNT() FROM clients;
SELECT COUNT() FROM memberships;
SELECT COUNT(*) FROM clients, memberships;

– Результат:
– clients = 5
– memberships = 9
– clients, memberships = 45

– 5 × 9 = 45.
– CROSS JOIN створює всі можливі комбінації рядків двох таблиць,
– тому кількість результатів дорівнює добутку кількості рядків.