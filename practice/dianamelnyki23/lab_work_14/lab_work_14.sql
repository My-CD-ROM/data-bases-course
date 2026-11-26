.bail off
.headers on
.mode column
PRAGMA foreign_keys = ON;

SELECT id, membership_id, client_id, purchase_date, expiration_date
FROM membership_sales WHERE id = 10;
BEGIN;
INSERT INTO membership_sales (membership_id, client_id, purchase_date, expiration_date)
VALUES (3, 2, '2026-10-11', '2026-11-10');
UPDATE membership_sales
SET expiration_date = '2026-10-11'
WHERE id = 10 AND client_id = 2;
SELECT id, membership_id, client_id, purchase_date, expiration_date
FROM membership_sales WHERE client_id = 2 ORDER BY id;
COMMIT;
SELECT id, membership_id, client_id, purchase_date, expiration_date
FROM membership_sales WHERE client_id = 2 ORDER BY id;

BEGIN;
INSERT INTO membership_sales (membership_id, client_id, purchase_date, expiration_date)
VALUES (2, 7, '2026-10-12', '2026-10-19');
SELECT id, membership_id, client_id, purchase_date, expiration_date
FROM membership_sales WHERE client_id = 7 ORDER BY id;
ROLLBACK;
SELECT id, membership_id, client_id, purchase_date, expiration_date
FROM membership_sales WHERE client_id = 7 ORDER BY id;

BEGIN;
INSERT INTO visits (client_id, visit_date, duration_minutes, visit_type)
SELECT 7, '2026-10-12', 45, visit_type FROM visits WHERE id = 1;
SELECT id, client_id, visit_date, duration_minutes, visit_type
FROM visits WHERE client_id = 7 AND visit_date = '2026-10-12';
ROLLBACK;

BEGIN;
INSERT INTO clients (last_name, first_name, phone, birth_date)
VALUES ('TxnDemo14', 'Rollback', '+380670000141', '2000-01-01');
INSERT INTO clients (last_name, first_name, phone, birth_date)
VALUES ('TxnDemo14', 'Duplicate', '+380670000141', '2000-01-02');
SELECT id, last_name, first_name, phone FROM clients WHERE phone = '+380670000141';
ROLLBACK;
SELECT id, last_name, first_name, phone FROM clients WHERE phone = '+380670000141';

BEGIN;
INSERT INTO clients (last_name, first_name, phone, birth_date)
VALUES ('TxnDemo14', 'CommittedPart', '+380670000142', '2000-02-01');
INSERT INTO clients (last_name, first_name, phone, birth_date)
VALUES ('TxnDemo14', 'Duplicate', '+380670000142', '2000-02-02');
SELECT id, last_name, first_name, phone FROM clients WHERE phone = '+380670000142';
COMMIT;
SELECT id, last_name, first_name, phone FROM clients WHERE phone = '+380670000142';

SELECT id, membership_id, client_id, purchase_date, expiration_date
FROM membership_sales WHERE client_id = 2 ORDER BY id;
SELECT id, client_id, visit_date FROM visits WHERE client_id = 7 AND visit_date = '2026-10-12';
SELECT id, last_name, first_name, phone FROM clients
WHERE phone IN ('+380670000141', '+380670000142') ORDER BY phone;
