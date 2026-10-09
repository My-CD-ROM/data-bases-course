SELECT
    membership_id,
    COUNT(*) AS кількість_продажів
FROM membership_sales
GROUP BY membership_id
ORDER BY membership_id;

SELECT
    memberships.id,
    memberships.type,
    COUNT(membership_sales.id) AS кількість_продажів
FROM memberships
LEFT JOIN membership_sales
    ON membership_sales.membership_id = memberships.id
GROUP BY memberships.id
ORDER BY memberships.id;

SELECT
    membership_id,
    COUNT(*) AS кількість_продажів,
    ROUND(AVG(id), 2) AS середній_id_продажу
FROM membership_sales
GROUP BY membership_id
ORDER BY membership_id;

SELECT
    membership_id,
    purchase_date,
    COUNT(*) AS кількість_продажів
FROM membership_sales
GROUP BY membership_id, purchase_date
ORDER BY membership_id, purchase_date;

SELECT
    membership_id,
    expiration_date,
    COUNT(*) AS кількість_продажів
FROM membership_sales
GROUP BY membership_id
ORDER BY membership_id;