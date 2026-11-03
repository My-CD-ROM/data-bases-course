PRAGMA foreign_keys = ON;

-- Завдання 1. 
SELECT
    ms.id,
    m.price AS raw_price,
    printf('%.2f грн', m.price) AS formatted_price
FROM membership_sales AS ms
JOIN memberships AS m ON ms.membership_id = m.id;

-- Завдання 2. 
SELECT
    ms.id,
    printf('%8.2f', m.price) AS formatted_price
FROM membership_sales AS ms
JOIN memberships AS m ON ms.membership_id = m.id;

-- Завдання 3.
SELECT
    id,
    purchase_date,
    expiration_date,
    date(expiration_date, '+30 days') AS extended_expiration_date
FROM membership_sales;

-- Завдання 4. 
SELECT
    strftime('%Y', purchase_date) AS sale_year,
    COUNT(*) AS sales_count
FROM membership_sales
GROUP BY strftime('%Y', purchase_date)
ORDER BY sale_year;

-- Завдання 5.
SELECT
    strftime('%Y', 'not-a-date') AS invalid_year;