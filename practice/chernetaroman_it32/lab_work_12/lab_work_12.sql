PRAGMA foreign_keys = ON;

-- Завдання 1
SELECT
    id,
    membership_id,
    client_id,
    purchase_date,
    expiration_date
FROM membership_sales
ORDER BY purchase_date DESC;


-- Завдання 2
SELECT
    id,
    membership_id,
    client_id,
    purchase_date,
    expiration_date
FROM membership_sales
ORDER BY expiration_date ASC, purchase_date DESC;


-- Завдання 3
SELECT
    id,
    membership_id,
    client_id,
    purchase_date,
    expiration_date
FROM membership_sales
ORDER BY purchase_date DESC
LIMIT 3;


-- Завдання 4а
SELECT DISTINCT
    type
FROM memberships;


-- Завдання 4а: кількість унікальних типів абонементів
SELECT
    COUNT(DISTINCT type) AS unique_types
FROM memberships;


-- Завдання 4б
SELECT
    id,
    client_id,
    membership_id,
    purchase_date,
    expiration_date
FROM membership_sales
WHERE client_id IN (1, 2, 3);


-- Завдання 5а
SELECT
    id,
    last_name,
    first_name
FROM clients
WHERE last_name LIKE 'К%';


-- Завдання 5б
SELECT
    COUNT(*) AS matches_upper
FROM clients
WHERE last_name LIKE 'К%';


-- Завдання 5в
SELECT
    COUNT(*) AS matches_lower
FROM clients
WHERE last_name LIKE 'к%';