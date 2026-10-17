SELECT
    COUNT(*) AS усі_продажі,
    COUNT(
        CASE WHEN id = 1 THEN NULL ELSE expiration_date END
    ) AS продажі_з_датою
FROM membership_sales;


SELECT
    SUM(price) AS сума_цін,
    ROUND(AVG(price), 2) AS середня_ціна
FROM memberships;


SELECT
    MIN(last_name) AS перше_прізвище,
    MAX(last_name) AS останнє_прізвище
FROM clients;

SELECT
    COUNT(*) AS кількість_продажів,
    MIN(purchase_date) AS перша_дата,
    MAX(purchase_date) AS остання_дата,
    COUNT(expiration_date) AS продажі_з_датою_завершення
FROM membership_sales;

SELECT
    COUNT(*) AS кількість_продажів,
    MIN(membership_sales.purchase_date) AS перша_дата,
    MAX(membership_sales.purchase_date) AS остання_дата
FROM membership_sales
INNER JOIN memberships
    ON membership_sales.membership_id = memberships.id
WHERE memberships.type = 'Місячний';

SELECT SUM(x) AS сума_лише_NULL
FROM (
    SELECT NULL AS x
    UNION ALL
    SELECT NULL AS x
);
