PRAGMA foreign_keys = ON;

-- Завдання 1

SELECT
    membership_sales.id AS sale_id,
    memberships.type AS membership_type,
    membership_sales.purchase_date,
    membership_sales.expiration_date
FROM membership_sales
INNER JOIN memberships
    ON membership_sales.membership_id = memberships.id
ORDER BY membership_sales.purchase_date;


-- Завдання 2

SELECT
    memberships.type AS membership_type,
    clients.last_name,
    clients.first_name,
    membership_sales.purchase_date,
    membership_sales.expiration_date
FROM membership_sales
INNER JOIN memberships
    ON membership_sales.membership_id = memberships.id
INNER JOIN clients
    ON membership_sales.client_id = clients.id
ORDER BY membership_sales.purchase_date;


-- Завдання 3

SELECT
    memberships.id,
    memberships.type,
    memberships.duration_days,
    memberships.price
FROM memberships
LEFT JOIN membership_sales
    ON membership_sales.membership_id = memberships.id
WHERE membership_sales.id IS NULL;


-- Завдання 4

SELECT COUNT(*) AS memberships_count
FROM memberships;

SELECT COUNT(*) AS clients_count
FROM clients;

SELECT COUNT(*) AS cross_join_count
FROM memberships, clients;
