-- Завдання 1
SELECT membership_id, COUNT(*) AS sales_count
FROM membership_sales
GROUP BY membership_id;

-- Завдання 2
SELECT memberships.type, COUNT(membership_sales.id) AS sales_count
FROM memberships
LEFT JOIN membership_sales ON membership_sales.membership_id = memberships.id
GROUP BY memberships.id;

-- Завдання 3
SELECT memberships.type,
       COUNT(membership_sales.id) AS sales_count,
       AVG(memberships.price) AS average_price
FROM memberships
LEFT JOIN membership_sales ON membership_sales.membership_id = memberships.id
GROUP BY memberships.id;

-- Завдання 4
SELECT membership_id, purchase_date, COUNT(*) AS sales_count
FROM membership_sales
GROUP BY membership_id, purchase_date;

-- Завдання 5
SELECT membership_id, client_id, COUNT(*) AS sales_count
FROM membership_sales
GROUP BY membership_id;