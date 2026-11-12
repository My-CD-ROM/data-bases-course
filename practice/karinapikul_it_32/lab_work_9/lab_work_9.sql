-- Практична робота № 9
-- Формування запитів з групуванням даних
-- Варіант: Спортзал

-- Завдання 1. Підрахунок продажів кожного типу абонемента
SELECT membership_id, COUNT(*) AS sales_count
FROM membership_sales
GROUP BY membership_id;

-- Завдання 2. Назви абонементів і кількість продажів
SELECT memberships.type, COUNT(membership_sales.id) AS sales_count
FROM memberships
LEFT JOIN membership_sales
    ON membership_sales.membership_id = memberships.id
GROUP BY memberships.id;

-- Завдання 3. Кількість продажів і середня ціна абонемента
SELECT memberships.type,
       COUNT(membership_sales.id) AS sales_count,
       AVG(memberships.price) AS average_price
FROM memberships
LEFT JOIN membership_sales
    ON membership_sales.membership_id = memberships.id
GROUP BY memberships.id;

-- Завдання 4. Групування за клієнтом та абонементом
SELECT client_id, membership_id, COUNT(*) AS sales_count
FROM membership_sales
GROUP BY client_id, membership_id;

-- Завдання 5. Приклад неоднозначного стовпця в GROUP BY
-- membership_id не входить до GROUP BY і не є агрегатною функцією.
SELECT client_id, membership_id, COUNT(*) AS sales_count
FROM membership_sales
GROUP BY client_id;
