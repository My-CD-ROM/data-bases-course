SELECT
    membership_id,
    COUNT(*) AS кількість_продажів
FROM membership_sales
GROUP BY membership_id;

SELECT
    m.id,
    m.type,
    COUNT(ms.id) AS кількість_продажів
FROM memberships AS m
LEFT JOIN membership_sales AS ms
    ON ms.membership_id = m.id
GROUP BY m.id;

SELECT
    membership_id,
    COUNT(*) AS кількість_продажів,
    AVG(id) AS середній_id_продажу
FROM membership_sales
GROUP BY membership_id;

SELECT
    membership_id,
    client_id,
    COUNT(*) AS кількість_продажів
FROM membership_sales
GROUP BY membership_id, client_id;

SELECT
    membership_id,
    client_id,
    COUNT(*) AS кількість_продажів
FROM membership_sales
GROUP BY membership_id;