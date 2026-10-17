# Practice 18 — Writing functions in PostgreSQL (PL/pgSQL)

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `script.sql`, `pharmacy_db_dump.sql` (db artifact), this `readme.md`.
Runs against `pharmacy_db` (schema from Practice 16, self-contained).

## Task 1 — Scalar function with a calculation
```sql
CREATE OR REPLACE FUNCTION retail_price(p_price NUMERIC)
RETURNS NUMERIC AS $$
BEGIN RETURN ROUND(p_price * 1.25, 2); END;
$$ LANGUAGE plpgsql;

SELECT id, purchase_price, retail_price(purchase_price) AS retail FROM deliveries ...;
```
The function adds a 25% margin to the purchase price (retail price). Result over the 20
deliveries: e.g. `24.81 → 31.01`, `88.13 → 110.16`, `64.92 → 81.15`.

## Task 2 — Scalar function with conditional logic (IF/ELSIF/ELSE)
```sql
CREATE OR REPLACE FUNCTION price_segment(p_price NUMERIC) RETURNS TEXT AS $$
BEGIN
    IF p_price < 40 THEN RETURN 'budget';
    ELSIF p_price < 80 THEN RETURN 'mid-range';
    ELSE RETURN 'premium'; END IF;
END; $$ LANGUAGE plpgsql;
```
Classification of the 12 medicines (checked against the limits):
- **budget** (< 40): Activated charcoal (15), Validol (20), Paracetamol (25), Mukaltin (30)
- **mid-range** (40–79.99): Loratadine (40), Ibuprofen (45), Aspirin (55), Vitamin C (60),
  Amoxicillin (65)
- **premium** (≥ 80): Cough syrup (85), Burn cream (95), No-Spa (110)

Boundary verification — each category correctly matches its bounds:
```
39.9 -> budget      40.0 -> mid-range
79.9 -> mid-range   80.0 -> premium
```

## Task 3 — A function that returns a table
```sql
CREATE OR REPLACE FUNCTION deliveries_by_supplier(p_supplier TEXT)
RETURNS TABLE(medicine TEXT, delivery_date DATE, quantity INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT m.name, d.delivery_date, d.quantity
    FROM deliveries d JOIN medicines m ON m.id = d.medicine_id
                      JOIN suppliers s ON s.id = d.supplier_id
    WHERE s.name = p_supplier;
END; $$ LANGUAGE plpgsql;

SELECT * FROM deliveries_by_supplier('Pharmpostach');
```
Returns 4 rows (Mukaltin, Cough syrup, Amoxicillin, Mukaltin with their quantities) — an
**exact match** to the plain `SELECT ... WHERE s.name = 'Pharmpostach'` with the same value,
confirming the function behaves identically to a parameterised WHERE.

## Task 4 — Intentional error: COMMIT inside a function
```sql
CREATE FUNCTION bad_commit(p_id INTEGER) RETURNS void AS $$
BEGIN
    UPDATE medicines SET stock_quantity = stock_quantity + 10 WHERE id = p_id;
    COMMIT;                       -- illegal inside a function
END; $$ LANGUAGE plpgsql;

SELECT bad_commit(1);
```
Exact PostgreSQL error (raised at the CALL / invocation, not at CREATE):
```
ERROR:  invalid transaction termination
CONTEXT:  PL/pgSQL function bad_commit(integer) line 4 at COMMIT
```
**Why:** a function runs inside the caller's transaction and may not manage it — only
procedures may execute transaction-control statements (`COMMIT`/`ROLLBACK`).

## Task 5 — A function inside WHERE
```sql
SELECT name, price FROM medicines WHERE price_segment(price) = 'premium' ORDER BY price;
```
Returns Cough syrup (85), Burn cream (95), No-Spa (110) — the premium medicines.
**Why this is more readable than writing the CASE inline:** the condition reads
`WHERE price_segment(price) = 'premium'` — one named, reusable function — instead of
repeating the full `CASE WHEN price < 40 ... END = 'premium'` (or a chain of `AND/OR`
comparisons) inside the WHERE of every query that needs it.

## Review questions and answers

**1. How is `RETURNS TABLE(...)` fundamentally different from an ordinary `RETURNS INTEGER`/`RETURNS TEXT` — what can you do with the result in one case and not the other?**

`RETURNS TABLE(...)` returns a **set of rows** (0 or more) with named columns, so its
result can be consumed like a table in `SELECT * FROM func(...)`, joined against other
tables, ordered, filtered, fed into other set operations, etc. An ordinary scalar
`RETURNS INTEGER`/`TEXT` returns exactly **one** value, usable in expressions, column
positions, and as a single filter value — but it cannot be queried as a row source.

**2. Why does the Task 4 error arise at the moment of CALLING the function (`SELECT bad_commit(1)`), not at `CREATE FUNCTION`?**

At `CREATE FUNCTION` PostgreSQL only checks and stores the function body; the PL/pgSQL
body is **compiled/executed lazily** when called. The invalid `COMMIT` sits inside a
`BEGIN ... END` block that is only executed on invocation, so the `invalid transaction
termination` error surfaces at the call, not at creation.

**3. Which of your functions (Tasks 1–3) could replace the view from Practice 17, and which could not, and why?**

`deliveries_by_supplier` (Task 3) returns rows with a parameter (the supplier), so it
could serve a similar role to a view built on a JOIN — but a normal view is **fixed**
(no parameters), while a function takes an argument; a *parametric* "view" would be done
with a function. The scalar value-returning functions (Tasks 1, 2) **cannot** replace a
view because they return a single value/classification, not a queryable table of rows.
Views and set-returning functions overlap; scalar functions do not.

## How to run
```bash
psql -h /tmp -p 5433 -U postgres -d pharmacy_db -f script.sql
```
The `invalid transaction termination` error in Task 4 is the expected intentional error.
