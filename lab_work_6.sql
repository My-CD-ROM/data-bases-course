PRAGMA foreign_keys = ON;

UPDATE medicines 
SET price = 120.50 
WHERE id = 1;

SELECT COUNT(*) AS count_before FROM deliveries;

DELETE FROM deliveries 
WHERE id = 2;

SELECT COUNT(*) AS count_after FROM deliveries;


DELETE FROM medicines 
WHERE id = 1;

SELECT * FROM deliveries WHERE medicine_id = 1;