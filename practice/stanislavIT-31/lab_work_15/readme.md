# Practice 15 — Generated (VIRTUAL) columns in SQLite

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `medicines.db`, `script.sql`, this `readme.md`.

## Task 1 — Derived numeric value: stock value
```sql
ALTER TABLE medicines ADD COLUMN stock_value REAL
    GENERATED ALWAYS AS (price * stock_quantity) VIRTUAL;
SELECT name, price, stock_quantity, stock_value FROM medicines ORDER BY name;
```
`stock_value` = price × stock on hand (e.g. No-Spa: 110 × 60 = 6600).
**Business sense of the formula:** it is the money currently "frozen" in the warehouse
for each medicine — price per unit multiplied by the number of units in stock. It's a
derived figure always kept in sync automatically.

## Task 2 — Derived logical flag
```sql
ALTER TABLE medicines ADD COLUMN low_stock INTEGER
    GENERATED ALWAYS AS (stock_quantity < 60) VIRTUAL;
SELECT name, stock_quantity, low_stock FROM medicines ORDER BY low_stock DESC, name;
```
The comparison `stock_quantity < 60` yields 1/0. Amoxicillin (50), Burn cream (35) and
Cough syrup (40) have `low_stock = 1`; all others have enough stock (0). Verified against
the actual stock counts.

## Task 3 — Intentional error: direct write to a generated column
```sql
UPDATE medicines SET stock_value = 1 WHERE id = 1;
```
Exact SQLite error:
```
Parse error near line 67: cannot UPDATE generated column "stock_value"
```

## Task 4 — Automatic recalculation
- Before: Paracetamol `price = 25.0`, `stock_value = 3000.0`.
- Then `UPDATE medicines SET price = 30.0 WHERE id = 1;` (the **base** column).
- After: `price = 30.0`, `stock_value = 3600.0` — recomputed **automatically and
  synchronously** with the base column change, with no extra command and no touch of the
  generated column by us.

## Task 5 — WHERE over a generated column
```sql
SELECT name, price, stock_quantity, stock_value
FROM medicines WHERE stock_value > 3000 ORDER BY stock_value DESC;
```
Returns No-Spa (6600), Vitamin C (6600), Aspirin (4400), Ibuprofen (4050), Paracetamol
(3600 after its price change), Cough syrup (3400), Burn cream (3325), Amoxicillin (3250).
**Why this is clearer than repeating the formula in WHERE:** the condition reads
`WHERE stock_value > 3000` — a single semantic name — instead of having to re-type and
re-explain `WHERE price * stock_quantity > 3000` in every query. It names the business
concept once, in the schema, and keeps `WHERE` simple and consistent everywhere it's used.

## Review questions and answers

**1. Why can this practice create only VIRTUAL, not STORED, generated columns — what does that tell you about an existing table?**

`ALTER TABLE ADD COLUMN ... GENERATED ALWAYS AS ...` on an **already existing** table
only permits **VIRTUAL** columns. A `STORED` generated column would require SQLite to
physically write and maintain the computed value in the existing table rows, which is not
supported for `ALTER TABLE ADD COLUMN`; a VIRTUAL column is computed on the fly and never
stored, so it can be added to an existing table without rewriting it. (STORED columns are
only allowed at initial `CREATE TABLE` time or via a full table rebuild.)

**2. What happens to a generated column's value if its base column is dropped (DROP COLUMN, beyond this course)?**

The generated column depends on the dropped base column, so the database would no longer
be able to compute it. Dropping a base column that a generated column depends on results
in an error / an invalid schema — the derived column and its formula must also be removed
or redefined. The dependency means a generated column's fate is tied to its source columns.

**3. Why is the impossibility of a direct INSERT/UPDATE into a generated column (Task 3) an advantage, not a limitation?**

Because it **guarantees consistency**: nobody can store a value in `stock_value` that
contradicts `price * stock_quantity`. The DBMS is the only writer of derived state, so the
derived value always matches the base data by construction. This removes a whole class of
"application forgot to update the derived field" bugs.

## How to run
```bash
sqlite3 medicines.db < script.sql
```
The `cannot UPDATE generated column` error in Task 3 is the expected intentional error.
