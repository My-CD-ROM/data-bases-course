-- ============================================================
-- Practice 14. Importing data from CSV into SQLite
-- Variant 4: Apteka (Pharmacy)
-- Import 8 new rows of v4_new_rows.csv into the dimension table 1
-- (medicines) through a STAGING table, because a direct .import into a
-- table with an id column does not work.
--
-- Run with:  sqlite3 medicines.db < script.sql
-- (this script uses CLI dot-commands: .mode, .import)
-- ============================================================

PRAGMA foreign_keys = ON;

-- ---------- Recreate dimension table 1 (self-contained) ----------
DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS medicines;

CREATE TABLE medicines (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    manufacturer TEXT,
    form TEXT,
    price REAL NOT NULL,
    stock_quantity INTEGER NOT NULL DEFAULT 0
);
INSERT INTO medicines (name, manufacturer, form, price, stock_quantity) VALUES
    ('Paracetamol', 'Darnytsia', 'tablets', 25.0, 120),
    ('Ibuprofen', 'Pharmak', 'tablets', 45.0, 90),
    ('No-Spa', 'Chinoin', 'tablets', 110.0, 60),
    ('Aspirin', 'Bayer', 'tablets', 55.0, 80),
    ('Mukaltin', 'Ternopharm', 'tablets', 30.0, 100),
    ('Validol', 'Darnytsia', 'tablets', 20.0, 70),
    ('Amoxicillin', 'Kyivmedpreparat', 'capsules', 65.0, 50),
    ('Loratadine', 'Pharmak', 'tablets', 40.0, 65),
    ('Cough syrup', 'Ternopharm', 'syrup', 85.0, 40),
    ('Burn cream', 'Darnytsia', 'ointment', 95.0, 35),
    ('Vitamin C', 'Pharmak', 'tablets', 60.0, 110),
    ('Activated charcoal', 'Kyivmedpreparat', 'tablets', 15.0, 150);

-- ============================================================
-- Task 1. Count BEFORE the import
-- ============================================================
SELECT COUNT(*) AS medicines_count_before FROM medicines;

-- ============================================================
-- Task 2. Staging table + CSV import
-- The staging table has columns matching the CSV header exactly
-- (name, manufacturer, form, price, stock_quantity), WITHOUT id.
-- ============================================================
CREATE TABLE medicines_staging (
    name TEXT,
    manufacturer TEXT,
    form TEXT,
    price REAL,
    stock_quantity INTEGER
);

.mode csv
.import --skip 1 v4_new_rows.csv medicines_staging

-- Check the staging table content
.mode list
SELECT 'staging_rows', COUNT(*) FROM medicines_staging;

-- ============================================================
-- Task 3. Move into the real table, drop staging, count again
-- ============================================================
INSERT INTO medicines (name, manufacturer, form, price, stock_quantity)
SELECT name, manufacturer, form, price, stock_quantity FROM medicines_staging;

DROP TABLE medicines_staging;

SELECT COUNT(*) AS medicines_count_after FROM medicines;
-- (8 new rows => difference exactly 8: count goes 12 -> 20)

-- ============================================================
-- Task 4. Verify the specific new rows arrived with continuing ids
-- ============================================================
SELECT id, name, price FROM medicines
WHERE name IN ('Німесил', 'Ренні', 'Ефералган', 'Ліностин',
               'Цитрамон', 'Кетанов', 'Фервекс', 'Смекта')
ORDER BY id;

-- ============================================================
-- Task 5. Intentional error: DIRECT import into the real table
-- Performed on a separate TEST copy of the database (medicines_test.db),
-- not on the working one. Direct .import into a table that HAS an id
-- column misaligns the columns. See readme.md for the exact result.
-- ============================================================
SELECT 'NOTE: Task 5 is executed separately on a test copy (medicines_test.db)';
