SELECT
    clients.last_name AS прізвище,
    clients.first_name AS ім_я,
    membership_sales.purchase_date AS дата_придбання
FROM membership_sales
INNER JOIN clients
    ON membership_sales.client_id = clients.id
ORDER BY membership_sales.purchase_date;

SELECT
    clients.last_name AS прізвище,
    clients.first_name AS ім_я,
    memberships.type AS тип_абонемента,
    membership_sales.purchase_date AS дата_придбання,
    membership_sales.expiration_date AS дата_завершення
FROM membership_sales
INNER JOIN clients
    ON membership_sales.client_id = clients.id
INNER JOIN memberships
    ON membership_sales.membership_id = memberships.id
WHERE memberships.price >= 1000
ORDER BY memberships.price DESC;

INSERT INTO memberships (type, duration_days, price)
SELECT 'Пробний абонемент', 3, 100
WHERE NOT EXISTS (
    SELECT 1
    FROM memberships
    WHERE type = 'Пробний абонемент'
);

SELECT
    memberships.type AS тип_абонемента,
    memberships.duration_days AS тривалість_днів,
    memberships.price AS ціна
FROM memberships
LEFT JOIN membership_sales
    ON memberships.id = membership_sales.membership_id
WHERE membership_sales.id IS NULL;

SELECT COUNT(*) AS кількість_пар
FROM memberships, clients;

SELECT COUNT(*) AS кількість_абонементів
FROM memberships;

SELECT COUNT(*) AS кількість_клієнтів
FROM clients;

