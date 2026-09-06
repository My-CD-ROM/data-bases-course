-- ============================================================
-- Practice 17. Creating and using Views in PostgreSQL
-- Variant 4: Apteka (Pharmacy)
-- Runs against the pharmacy_db database (schema from Practice 16).
-- This script is self-contained: it recreates the base schema and data
-- first, then demonstrates ordinary and materialized views (Lecture 19).
-- ============================================================

-- ---------- Base schema (self-contained, same state as Practice 16) ----------
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
-- Task 1. An ordinary filter view
-- "Medicines currently in sufficient stock" - a typical repeating query.
-- ============================================================
CREATE VIEW medicines_in_stock AS
SELECT id, name, manufacturer, form, price, stock_quantity
FROM medicines
WHERE stock_quantity >= 60;

SELECT * FROM medicines_in_stock ORDER BY name;

-- ============================================================
-- Task 2. The view is always "live"
-- Insert a new medicine that satisfies the WHERE condition, and check
-- the view BEFORE and AFTER - the new row appears with NO extra command.
-- ============================================================
SELECT COUNT(*) AS in_stock_before FROM medicines_in_stock;

INSERT INTO medicines (name, manufacturer, form, price, stock_quantity)
VALUES ('Nimesil', 'Berlin-Chemie', 'powder', 65.0, 45);  -- 45 < 60, NOT in view

-- Add one that DOES satisfy the condition:
INSERT INTO medicines (name, manufacturer, form, price, stock_quantity)
VALUES ('Smecta', 'Ipsen', 'powder', 95.0, 90);           -- 90 >= 60, WILL be in view

SELECT COUNT(*) AS in_stock_after FROM medicines_in_stock;
SELECT name, stock_quantity FROM medicines_in_stock WHERE name = 'Smecta';

-- ============================================================
-- Task 3. Write through a simple view
-- Insert directly INTO the view (single-table, no JOIN/aggregate).
-- ============================================================
INSERT INTO medicines_in_stock (name, manufacturer, form, price, stock_quantity)
VALUES ('Rennie', 'Bayer', 'tablets', 75.0, 88);

-- Check the base table: the row landed there; id was auto-generated,
-- and every column NOT listed in the view's SELECT is NOT in the insert
-- (the view exposes only the 6 plain columns, so nothing else to fill).
SELECT * FROM medicines WHERE name = 'Rennie';

-- ============================================================
-- Task 4. Materialized view and REFRESH
-- ============================================================
CREATE MATERIALIZED VIEW medicines_in_stock_mat AS
SELECT id, name, manufacturer, form, price, stock_quantity
FROM medicines
WHERE stock_quantity >= 60;

SELECT COUNT(*) AS mat_before FROM medicines_in_stock_mat;

-- Add another qualifying medicine to the base table:
INSERT INTO medicines (name, manufacturer, form, price, stock_quantity)
VALUES ('Efferalgan', 'Upsa', 'tablets', 90.0, 80);

SELECT COUNT(*) AS live_after_new_row    FROM medicines_in_stock;
SELECT COUNT(*) AS mat_before_refresh    FROM medicines_in_stock_mat;

REFRESH MATERIALIZED VIEW medicines_in_stock_mat;

SELECT COUNT(*) AS mat_after_refresh     FROM medicines_in_stock_mat;

-- ============================================================
-- Task 5. CREATE OR REPLACE VIEW
-- Change the ordinary view WITHOUT DROP: lower the stock threshold to
-- >= 80 and add the stock_quantity column focus. Verified by SELECT.
-- ============================================================
CREATE OR REPLACE VIEW medicines_in_stock AS
SELECT id, name, manufacturer, form, price, stock_quantity
FROM medicines
WHERE stock_quantity >= 80;

SELECT name, stock_quantity FROM medicines_in_stock ORDER BY name;
-- (The view now returns only medicines with stock >= 80; no DROP was used.)
