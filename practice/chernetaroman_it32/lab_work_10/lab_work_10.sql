
PRAGMA foreign_keys = ON;

-- Завдання 1
SELECT
    membership_id,
    COUNT(*) AS sales_count
FROM membership_sales
GROUP BY membership_id
HAVING COUNT(*) > 2;


-- Завдання 2
SELECT
    membership_sales.client_id,
    ROUND(AVG(memberships.price), 2) AS average_price
FROM membership_sales
JOIN memberships
    ON membership_sales.membership_id = memberships.id
GROUP BY membership_sales.client_id
HAVING AVG(memberships.price) > 1000;


-- Завдання 3
SELECT
    membership_id,
    COUNT(*) AS sales_count
FROM membership_sales
WHERE purchase_date >= '2026-01-01'
GROUP BY membership_id
HAVING COUNT(*) > 1;


-- Завдання 4
SELECT
    membership_id,
    COUNT(*) AS sales_count
FROM membership_sales
WHERE COUNT(*) > 1
GROUP BY membership_id;


-- Завдання 5
SELECT
    memberships.id AS membership_id,
    memberships.type AS membership_type,
    COUNT(membership_sales.id) AS sales_count
FROM memberships
LEFT JOIN membership_sales
    ON memberships.id = membership_sales.membership_id
GROUP BY memberships.id, memberships.type
HAVING COUNT(membership_sales.id) < 2;
