PRAGMA foreign_keys = ON;

UPDATE membership_sales
SET expiration_date = '2026-10-11'
WHERE id = 10;

SELECT * FROM membership_sales WHERE id = 10;

UPDATE memberships
SET price = 850
WHERE id = 6;

SELECT * FROM memberships WHERE id = 6;

SELECT COUNT(*) AS sales_before_delete
FROM membership_sales;

DELETE FROM membership_sales
WHERE id = 10;

SELECT COUNT(*) AS sales_after_delete
FROM membership_sales;
