-- ============================================================
-- Practice 19. Creating procedures in PostgreSQL (PL/pgSQL)
-- Variant 4: Apteka (Pharmacy)
-- Wrap the atomic pair from Practice 12 (INSERT delivery + UPDATE stock)
-- as a named PROCEDURE, and confirm why a procedure (not a function)
-- fits this task.
--
-- Run with:  psql -d pharmacy_db -f script.sql
-- ============================================================

-- ---------- Base schema (self-contained, same state as Practice 16) ----------
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
-- Task 1. Procedure for the atomic pair (from Practice 12)
-- A delivery record and the matching stock increase must happen
-- TOGETHER; a PROCEDURE can contain COMMIT (a function cannot).
-- ============================================================
CREATE OR REPLACE PROCEDURE record_delivery(
    p_medicine_id INTEGER,
    p_supplier_id INTEGER,
    p_quantity    INTEGER,
    p_price       NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO deliveries (medicine_id, supplier_id, delivery_date, quantity, purchase_price)
    VALUES (p_medicine_id, p_supplier_id, CURRENT_DATE, p_quantity, p_price);

    UPDATE medicines SET stock_quantity = stock_quantity + p_quantity
    WHERE id = p_medicine_id;

    COMMIT;
END;
$$;

-- ============================================================
-- Task 2. Call the procedure with real values, then verify BOTH changes
-- ============================================================
SELECT 'stock_before', stock_quantity FROM medicines WHERE id = 1;
SELECT 'count_before', COUNT(*) FROM deliveries;

CALL record_delivery(1, 1, 50, 20.00);   -- Paracetamol from Optima-Pharm

SELECT 'stock_after', stock_quantity FROM medicines WHERE id = 1;
SELECT 'count_after', COUNT(*) FROM deliveries;
-- (both the new delivery row and the stock increase must be present)

-- ============================================================
-- Task 3. Intentional error: CALL a procedure via SELECT
-- ============================================================
SELECT record_delivery(1, 1, 10, 9.00);
-- Expected exact PostgreSQL error + hint:
--   ERROR:  record_delivery(integer, integer, integer, numeric) is a procedure
--   HINT:  To call a procedure, use CALL.

-- ============================================================
-- Task 4. Procedure with conditional logic (RAISE EXCEPTION)
-- ============================================================
CREATE OR REPLACE PROCEDURE record_delivery_safe(
    p_medicine_id INTEGER,
    p_supplier_id INTEGER,
    p_quantity    INTEGER,
    p_price       NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_quantity <= 0 OR p_price < 0 THEN
        RAISE EXCEPTION 'quantity must be positive and price non-negative (got qty=%, price=%)',
            p_quantity, p_price;
    END IF;

    INSERT INTO deliveries (medicine_id, supplier_id, delivery_date, quantity, purchase_price)
    VALUES (p_medicine_id, p_supplier_id, CURRENT_DATE, p_quantity, p_price);

    UPDATE medicines SET stock_quantity = stock_quantity + p_quantity
    WHERE id = p_medicine_id;

    COMMIT;
END;
$$;

-- Valid call (must succeed):
SELECT 'valid_safe_before', COUNT(*) FROM deliveries;
CALL record_delivery_safe(2, 2, 30, 33.00);
SELECT 'valid_safe_after', COUNT(*) FROM deliveries;

-- Invalid call (negative quantity -> must raise):
CALL record_delivery_safe(3, 3, -5, 10.00);
-- Expected exact PostgreSQL error:
--   ERROR:  quantity must be positive and price non-negative (got qty=-5, price=10.0)

-- ============================================================
-- Task 5. (Written comparison with Practice 12 is in readme.md)
-- ============================================================
