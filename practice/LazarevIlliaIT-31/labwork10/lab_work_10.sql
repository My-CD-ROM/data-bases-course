SELECT
    membership_id,
    COUNT(*) AS кількість_продажів
FROM membership_sales
GROUP BY membership_id
HAVING COUNT(*) > 1;

SELECT
    ms.client_id,
    AVG(m.price) AS середня_ціна
FROM membership_sales AS ms
JOIN memberships AS m
    ON ms.membership_id = m.id
GROUP BY ms.client_id
HAVING AVG(m.price) > 500;

SELECT
    ms.clientid,
    COUNT(*) AS кількістьпокупок
FROM membership_sales AS ms
JOIN memberships AS m
    ON ms.membership_id = m.id
WHERE m.duration_days >= 30
GROUP BY ms.client_id
HAVING COUNT(*) > 1;

SELECT
    membershipid,
    COUNT(*) AS кількістьпродажів
FROM membership_sales
WHERE COUNT(*) > 1
GROUP BY membership_id;

SELECT
    m.id,
    m.type,
    COUNT(ms.id) AS кількість_продажів
FROM memberships AS m
LEFT JOIN membership_sales AS ms
    ON m.id = ms.membership_id
GROUP BY m.id
HAVING COUNT(ms.id) < 2;