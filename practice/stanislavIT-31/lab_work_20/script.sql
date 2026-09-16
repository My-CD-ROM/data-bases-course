-- ============================================================
-- Practice 20. Implementing triggers (final practice of the course)
-- Variant 4: Apteka (Pharmacy)
-- Two triggers over the medicines dimension table:
--   * AFTER  INSERT OR UPDATE -> logs every price change in medicines_log
--   * BEFORE INSERT OR UPDATE -> blocks a negative price (RAISE EXCEPTION)
--
-- Run with:  psql -d pharmacy_db -f script.sql
-- ============================================================

-- ---------- Base schema (self-contained, same state as Practice 16) ----------
DROP TRIGGER IF EXISTS trg_log_medicine_price ON medicines;
DROP TRIGGER IF EXISTS trg_check_medicine_price ON medicines;
DROP FUNCTION IF EXISTS log_medicine_price();
DROP FUNCTION IF EXISTS check_medicine_price();
DROP TABLE IF EXISTS medicines_log;
DROP PROCEDURE IF EXISTS record_delivery_safe(INTEGER, INTEGER, INTEGER, NUMERIC);
DROP PROCEDURE IF EXISTS record_delivery(INTEGER, INTEGER, INTEGER, NUMERIC);
DROP MATERIALIZED VIEW IF EXISTS medicines_in_stock_mat;
DROP VIEW IF EXISTS medicines_in_stock;
DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS medicines;

CREATE TABLE medicines (
    id               INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name             TEXT NOT NULL,
    manufacturer     TEXT,
    form             TEXT,
    price            NUMERIC NOT NULL,
    stock_quantity   INTEGER NOT NULL DEFAULT 0
);
CREATE TABLE suppliers (
    id               INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name             TEXT NOT NULL,
    contact_person   TEXT,
    phone            TEXT,
    city             TEXT
);
CREATE TABLE deliveries (
    id               INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    medicine_id      INTEGER NOT NULL REFERENCES medicines(id) ON DELETE RESTRICT,
    supplier_id      INTEGER NOT NULL REFERENCES suppliers(id) ON DELETE RESTRICT,
    delivery_date    DATE NOT NULL,
    quantity         INTEGER NOT NULL,
    purchase_price   NUMERIC
);

INSERT INTO medicines (id, name, manufacturer, form, price, stock_quantity)
    OVERRIDING SYSTEM VALUE VALUES
    (1,'Paracetamol','Darnytsia','tablets',25.0,120),
    (2,'Ibuprofen','Pharmak','tablets',45.0,90),
    (3,'No-Spa','Chinoin','tablets',110.0,60),
    (4,'Aspirin','Bayer','tablets',55.0,80),
    (5,'Mukaltin','Ternopharm','tablets',30.0,100),
    (6,'Validol','Darnytsia','tablets',20.0,70),
    (7,'Amoxicillin','Kyivmedpreparat','capsules',65.0,50),
    (8,'Loratadine','Pharmak','tablets',40.0,65),
    (9,'Cough syrup','Ternopharm','syrup',85.0,40),
    (10,'Burn cream','Darnytsia','ointment',95.0,35),
    (11,'Vitamin C','Pharmak','tablets',60.0,110),
    (12,'Activated charcoal','Kyivmedpreparat','tablets',15.0,150);
SELECT setval(pg_get_serial_sequence('medicines','id'), 12);

INSERT INTO suppliers (id, name, contact_person, phone, city)
    OVERRIDING SYSTEM VALUE VALUES
    (1,'Optima-Pharm','Taras Bondarenko','+380****0001','Lviv'),
    (2,'BaDM','Maria Rudenko','+380****0002','Kyiv'),
    (3,'Venta.Ltd','Yulia Kravets','+380****0003','Lviv'),
    (4,'Alba Ukraine','Oksana Honcharenko','+380****0004','Poltava'),
    (5,'Fra-M','Roman Lytvyn','+380****0005','Vinnytsia'),
    (6,'Medpharmcom','Sofia Zakharchenko','+380****0006','Odesa'),
    (7,'Liky Control','Maksym Oliinyk','+380****0007','Cherkasy'),
    (8,'Pharmacy Holding','Maksym Melnyk','+380****0008','Vinnytsia'),
    (9,'UniPharma','Andriy Lytvyn','+380****0009','Dnipro'),
    (10,'Pharmpostach','Bohdan Hrytsenko','+380****0010','Poltava'),
    (11,'Medzabezpechennia','Ihor Kravets','+380****0011','Odesa'),
    (12,'Lixem','Maksym Melnyk','+380****0012','Vinnytsia');
SELECT setval(pg_get_serial_sequence('suppliers','id'), 12);

INSERT INTO deliveries (id, medicine_id, supplier_id, delivery_date, quantity, purchase_price)
    OVERRIDING SYSTEM VALUE VALUES
    (1,5,10,'2025-09-01',76,85.85),(2,2,4,'2025-08-18',40,65.25),
    (3,11,12,'2025-08-26',12,17.44),(4,4,7,'2024-05-22',84,39.52),
    (5,9,9,'2025-07-24',80,36.46),(6,12,8,'2025-05-09',39,19.65),
    (7,4,6,'2024-12-18',98,24.81),(8,4,12,'2025-05-24',85,88.13),
    (9,9,10,'2025-02-27',34,33.70),(10,6,3,'2025-01-23',78,20.13),
    (11,1,1,'2025-12-05',91,79.48),(12,8,2,'2024-10-10',70,48.30),
    (13,6,3,'2024-05-28',71,19.13),(14,2,7,'2025-02-19',90,64.92),
    (15,3,3,'2025-02-08',25,54.65),(16,7,10,'2024-09-13',67,82.68),
    (17,5,10,'2025-05-19',89,14.82),(18,12,2,'2024-11-07',43,62.83),
    (19,3,4,'2024-09-03',30,10.21),(20,8,12,'2025-05-02',39,33.05);
SELECT setval(pg_get_serial_sequence('deliveries','id'), 20);

-- ============================================================
-- Task 1. The log (audit) table
-- ============================================================
CREATE TABLE medicines_log (
    id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    medicine_id  INTEGER NOT NULL,
    action       TEXT NOT NULL,
    old_price    NUMERIC,
    new_price    NUMERIC,
    logged_at    TIMESTAMP DEFAULT now()
);

-- ============================================================
-- Task 2. AFTER trigger that logs every change of the price column
-- ============================================================
CREATE OR REPLACE FUNCTION log_medicine_price() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO medicines_log (medicine_id, action, old_price, new_price)
        VALUES (NEW.id, 'INSERT', NULL, NEW.price);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO medicines_log (medicine_id, action, old_price, new_price)
        VALUES (NEW.id, 'UPDATE', OLD.price, NEW.price);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_medicine_price
AFTER INSERT OR UPDATE OF price ON medicines
FOR EACH ROW
EXECUTE FUNCTION log_medicine_price();

-- --- Test Task 2: an INSERT and an UPDATE produce log rows automatically ---
SELECT 'log_before', COUNT(*) FROM medicines_log;

INSERT INTO medicines (name, manufacturer, form, price, stock_quantity)
VALUES ('Nimesil', 'Berlin-Chemie', 'powder', 65.0, 45);

UPDATE medicines SET price = 28.0 WHERE id = 1;   -- Paracetamol 25 -> 28

SELECT 'log_after', COUNT(*) FROM medicines_log;
SELECT medicine_id, action, old_price, new_price FROM medicines_log ORDER BY id;

-- ============================================================
-- Task 3. BEFORE trigger that validates a business rule
-- Price must never be negative.
-- ============================================================
CREATE OR REPLACE FUNCTION check_medicine_price() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.price < 0 THEN
        RAISE EXCEPTION 'price cannot be negative (got %)', NEW.price;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_medicine_price
BEFORE INSERT OR UPDATE OF price ON medicines
FOR EACH ROW
EXECUTE FUNCTION check_medicine_price();

-- ============================================================
-- Task 4. Test the blocking
-- A negative price must be rejected and must NOT change the row.
-- ============================================================
SELECT 'paracetamol_price_before', price FROM medicines WHERE id = 1;

UPDATE medicines SET price = -5.0 WHERE id = 1;
-- Expected exact error:
--   ERROR:  price cannot be negative (got -5.0)

SELECT 'paracetamol_price_after', price FROM medicines WHERE id = 1;  -- still 28.0
SELECT 'row_still_exists', COUNT(*) FROM medicines WHERE id = 1;

-- ============================================================
-- Task 5. Final combined check of BOTH triggers together
--  a) a SUCCESSFUL change: passes the BEFORE check AND is logged by AFTER
--  b) a FAILED attempt: blocked by BEFORE, so it is NOT logged by AFTER
-- ============================================================
SELECT 'final_log_count_before', COUNT(*) FROM medicines_log;

-- (a) Successful: Set Ibuprofen (id=2) price 45 -> 52.
UPDATE medicines SET price = 52.0 WHERE id = 2;

-- (b) Failed: try to set price = -1 on id = 3 (blocked; NOT logged).
UPDATE medicines SET price = -1.0 WHERE id = 3;
-- Expected error:  ERROR:  price cannot be negative (got -1.0)

-- Verify:
SELECT 'final_log_count_after', COUNT(*) FROM medicines_log;
-- one extra log row appears ONLY for the successful change
SELECT medicine_id, action, old_price, new_price FROM medicines_log ORDER BY id;
-- (id=2 UPDATE present; no row for id=3)
SELECT 'no_spa_price', price FROM medicines WHERE id = 3;  -- unchanged (110.0)
