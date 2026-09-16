-- ============================================================
-- Practice 18. Writing functions in PostgreSQL (PL/pgSQL)
-- Variant 4: Apteka (Pharmacy)
-- Runs against pharmacy_db (schema from Practice 16, self-contained).
--
-- Run with:  psql -d pharmacy_db -f script.sql
-- ============================================================

-- ---------- Base schema (self-contained) ----------
-- Drop objects that might be left over from other practices and depend
-- on these tables (views from Practice 17).
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
-- Task 1. Scalar function with a calculation
-- Retail price = purchase price + 25% (VAT/margin example).
-- ============================================================
CREATE OR REPLACE FUNCTION retail_price(p_price NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN ROUND(p_price * 1.25, 2);
END;
$$ LANGUAGE plpgsql;

SELECT id, purchase_price, retail_price(purchase_price) AS retail
FROM deliveries
WHERE purchase_price IS NOT NULL
ORDER BY id;

-- ============================================================
-- Task 2. Scalar function with conditional logic (IF/ELSIF/ELSE)
-- Classify a medicine by price into 3+ segments.
-- ============================================================
CREATE OR REPLACE FUNCTION price_segment(p_price NUMERIC)
RETURNS TEXT AS $$
BEGIN
    IF p_price  < 40 THEN
        RETURN 'budget';
    ELSIF p_price < 80 THEN
        RETURN 'mid-range';
    ELSE
        RETURN 'premium';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Call it for every medicine and verify each category against the bounds:
SELECT name, price, price_segment(price) AS segment
FROM medicines
ORDER BY price;

-- Verify boundaries explicitly:
SELECT '39.9' AS price, price_segment(39.9)  AS seg -- budget
UNION ALL SELECT '40.0', price_segment(40.0)        -- mid-range
UNION ALL SELECT '79.9', price_segment(79.9)        -- mid-range
UNION ALL SELECT '80.0', price_segment(80.0);       -- premium

-- ============================================================
-- Task 3. A function that returns a table
-- Deliveries made by a given supplier (by name).
-- ============================================================
CREATE OR REPLACE FUNCTION deliveries_by_supplier(p_supplier TEXT)
RETURNS TABLE(medicine TEXT, delivery_date DATE, quantity INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT m.name, d.delivery_date, d.quantity
    FROM deliveries d
    JOIN medicines m  ON m.id = d.medicine_id
    JOIN suppliers s  ON s.id = d.supplier_id
    WHERE s.name = p_supplier;
END;
$$ LANGUAGE plpgsql;

-- Verify it matches a plain SELECT ... WHERE with the same value:
SELECT * FROM deliveries_by_supplier('Pharmpostach');

SELECT m.name AS medicine, d.delivery_date, d.quantity
FROM deliveries d
JOIN medicines m ON m.id = d.medicine_id
JOIN suppliers s ON s.id = d.supplier_id
WHERE s.name = 'Pharmpostach';

-- ============================================================
-- Task 4. Intentional error: COMMIT inside a function
-- Functions must NOT manage transactions. The error appears at CALL time.
-- ============================================================
CREATE OR REPLACE FUNCTION bad_commit(p_id INTEGER)
RETURNS void AS $$
BEGIN
    UPDATE medicines SET stock_quantity = stock_quantity + 10 WHERE id = p_id;
    COMMIT;  -- illegal inside a function
END;
$$ LANGUAGE plpgsql;

-- Calling it raises an error:
SELECT bad_commit(1);
-- Expected exact PostgreSQL error:
--   ERROR:  invalid transaction termination
--   CONTEXT:  PL/pgSQL function bad_commit(integer) line 5 at COMMIT

-- ============================================================
-- Task 5. A function inside WHERE
-- ============================================================
SELECT name, price
FROM medicines
WHERE price_segment(price) = 'premium'
ORDER BY price;
