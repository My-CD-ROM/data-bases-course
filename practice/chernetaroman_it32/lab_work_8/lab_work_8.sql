PRAGMA foreign_keys = ON;

-- Завдання 1
SELECT
    COUNT(*) AS total_memberships,
    COUNT(duration_days) AS memberships_with_duration
FROM memberships;

-- Завдання 2
SELECT
    SUM(price) AS total_price,
    ROUND(AVG(price), 2) AS average_price
FROM memberships;

-- Завдання 3
SELECT
    MIN(purchase_date) AS earliest_purchase,
    MAX(purchase_date) AS latest_purchase
FROM membership_sales;

-- Завдання 4
SELECT
    COUNT(*) AS sales_count,
    SUM(m.price) AS total_sales_value,
    ROUND(AVG(m.price), 2) AS average_membership_price,
    MIN(ms.purchase_date) AS first_purchase,
    MAX(ms.purchase_date) AS last_purchase
FROM membership_sales AS ms
JOIN memberships AS m
    ON ms.membership_id = m.id;

-- Завдання 5
SELECT
    COUNT(*) AS monthly_sales_count,
    SUM(m.price) AS monthly_sales_value,
    ROUND(AVG(m.price), 2) AS monthly_average_price
FROM membership_sales AS ms
JOIN memberships AS m
    ON ms.membership_id = m.id
WHERE m.type = 'Місячний';
