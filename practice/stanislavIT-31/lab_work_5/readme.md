# Practice 5 — UPDATE and DELETE commands in SQLite

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `medicines.db`, `script.sql`, this `readme.md`.

## Task 1 — UPDATE one row in the fact table
Delivery `id = 12` had its `purchase_price` still missing ("temporary" value). It was
confirmed with:
```sql
UPDATE deliveries SET purchase_price = 48.30 WHERE id = 12;
```
`WHERE id = 12` (on the primary key) ensures **exactly one** row is updated.

## Task 2 — UPDATE one "changeable" indicator in a dimension table
The `stock_quantity` of Amoxicillin (`medicines.id = 7`) was adjusted after a sale:
```sql
UPDATE medicines SET stock_quantity = 44 WHERE id = 7;
```
**Why UPDATE and not DELETE + INSERT:** the row still represents the same real medicine;
we only want to change one of its attributes. `DELETE` + `INSERT` would destroy the
stable `id` (and any rows referencing it), re-write every column unnecessarily, and
lose the row's history — while `UPDATE` changes exactly the one indicator that changed.

## Task 3 — DELETE exactly one row
Delivery `id = 6` (a mistaken record) was cancelled:
```sql
SELECT COUNT(*) AS count_before FROM deliveries;  -- 12
DELETE FROM deliveries WHERE id = 6;
SELECT COUNT(*) AS count_after FROM deliveries;   -- 11
```
The counts prove **exactly one** row disappeared (12 → 11).

## Task 4 — Integrity-constraint check on UPDATE
A deliberately failing update was attempted:
```sql
UPDATE deliveries SET quantity = NULL WHERE id = 1;
```
Exact SQLite error:
```
Error near line 131: NOT NULL constraint failed: deliveries.quantity
```
The `NOT NULL` constraint on `deliveries.quantity` (declared at `CREATE TABLE`) still
acts on `UPDATE`, not only on `INSERT` — exactly as the practice intended to demonstrate.

## Task 5 — DELETE/UPDATE without WHERE (analysis, NOT executed)
The command was **not** run on the real database; the consequences were reasoned about
using `SELECT COUNT(*)` (current fact table has **11** rows):

- If `WHERE` were removed from the Task-1 `UPDATE deliveries SET purchase_price = ...`,
  it would update **all 11** rows of the fact table instead of one — every delivery would
  get the same `purchase_price`, corrupting the whole ledger.
- If `WHERE` were removed from the Task-3 `DELETE FROM deliveries`, it would delete
  **all 11** rows — emptying the fact table entirely.
- (Deleting from a dimension table without `WHERE` would additionally be blocked by the
  `ON DELETE RESTRICT` foreign keys for any supplier/medicine with deliveries.)

For the current database the number of affected rows would be **11** (the whole table).

## Review questions and answers

**1. How does `UPDATE ... SET column = column + 1` differ from `UPDATE ... SET column = <specific number>`?**

The first form is **relative** — it reads the current value of each row and adds 1 to it,
so each row ends with a different result based on its own prior value. The second form is
**absolute** — it writes the same fixed number into every matched row regardless of what
was there before.

**2. Why are NOT NULL/UNIQUE/CHECK always checked on UPDATE, while FOREIGN KEY is only checked if `PRAGMA foreign_keys = ON`?**

`NOT NULL`, `UNIQUE` and `CHECK` are row/column constraints whose enforcement is
built into the core of SQLite and always active. In contrast, foreign-key enforcement is
an **opt-in** feature whose default in SQLite is **off**; it is enabled per connection via
`PRAGMA foreign_keys = ON`, so without that PRAGMA an update can break a reference with
no error.

**3. If the FK on the fact table were `ON DELETE CASCADE` instead of `RESTRICT`, how would deleting a row from the referenced dimension table differ?**

With `CASCADE`, deleting a medicine/supplier row would **automatically delete** all its
deliveries from the fact table as well. With `RESTRICT` (as chosen here) such a deletion
is **refused** while dependent delivery rows exist — protecting the accounting history.

**4. Why is `DELETE` without `WHERE` more dangerous than a type error or a constraint violation?**

A type error or constraint violation is **caught and reported** by the DBMS and changes
nothing. `DELETE` (or `UPDATE`) without `WHERE` **silently and destructively** affects
every row in the table — it executes successfully, and if no backup exists the data is
irrecoverably gone with no error message warning the developer.

## How to run
```bash
sqlite3 medicines.db < script.sql
```
The `NOT NULL constraint failed` message in Task 4 is the expected intentional error.
