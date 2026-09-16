# Practice 4 — Adding records, setting keys and relationships

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `medicines.db` (SQLite database), `script.sql`, this `readme.md`.

## The resulting schema (matches the ER diagram from Practice 3)

```
medicines(id, name, manufacturer, form, price, stock_quantity)         -- dimension 1
suppliers(id, name, contact_person, phone, city)                       -- dimension 2
deliveries(id, medicine_id FK -> medicines.id,                         -- fact table
           supplier_id FK -> suppliers.id,
           delivery_date, quantity, purchase_price)
```

## Task 1 — Enabling checks and dimension table 2
`PRAGMA foreign_keys = ON;` was run as the first line of the session, then
dimension table 2 `suppliers` was created with the primary key `id INTEGER PRIMARY KEY`
and sensible types: `id`/`name`/`contact_person`/`phone`/`city` as TEXT (city is really
text), `id` as INTEGER.

## Task 2 — Fact table with two FOREIGN KEYs and the ON DELETE choice

The fact table `deliveries` has two foreign keys, one to each dimension table.

**Choice of ON DELETE actions (with business justification, not "the easiest to write"):**

- `medicine_id FOREIGN KEY ... ON DELETE RESTRICT` — a delivery record is part of the
  pharmacy's accounting history. If a medicine row that has ever been delivered were
  deleted, that history would become inconsistent (a delivery would reference nothing).
  `RESTRICT` forbids deleting such a medicine, which protects the ledger's integrity.
- `supplier_id FOREIGN KEY ... ON DELETE RESTRICT` — by the same logic, the delivery
  ledger must keep records of every supplier that ever brought goods. Deleting a
  supplier who has deliveries would leave orphaned references, so `RESTRICT` is the
  correct behaviour for this domain (a `CASCADE` would silently destroy accounting
  history; a `SET NULL` would make deliveries look like they "came from nowhere").

## Task 3 — Populating with linked data
- 6 rows inserted into `suppliers` (dimension table 2).
- 10 rows inserted into `deliveries` (fact table), each correctly linked to existing
  `medicines.id` and `suppliers.id` — no fabricated foreign key values.

## Task 4 — Intentional foreign key error
```sql
INSERT INTO deliveries (medicine_id, supplier_id, delivery_date, quantity, purchase_price)
VALUES (9999, 1, '2026-03-10', 5, 10.00);
```
Exact error output from SQLite:
```
Error near line 90: FOREIGN KEY constraint failed
```
The row was **not** inserted (a `SELECT COUNT(*) WHERE medicine_id = 9999` returns 0).
This confirms `PRAGMA foreign_keys = ON` genuinely works on this connection.

## Task 5 — Comparison with the ER diagram of Practice 3
The actually created structure exactly implements what was designed in Practice 3:
the same three table names, the same column names, the same primary keys, and the same
direction of both foreign keys (`deliveries.medicine_id -> medicines.id`,
`deliveries.supplier_id -> suppliers.id`). No column name, data type or relationship
direction had to be changed — the design planned on paper was realised as-is.

## Review questions and answers

**1. Why is `PRAGMA foreign_keys = ON;` needed if `FOREIGN KEY` is already declared in `CREATE TABLE`, and why must it be repeated on every new connection?**

In SQLite foreign key enforcement is **off by default**. Declaring `FOREIGN KEY` in
`CREATE TABLE` merely describes the constraint; it does not turn on checking. The
`PRAGMA` is a per-connection setting — it is not stored in the database file, so a new
connection starts with enforcement disabled and the statement has to be run again.

**2. What is the fundamental difference between PRIMARY KEY and FOREIGN KEY — what does each identify or reference?**

A `PRIMARY KEY` **uniquely identifies a row within its own table** — its value must be
unique and non-null (e.g. `medicines.id`). A `FOREIGN KEY` in one table **references
the primary key of another table** — it stores a value that must exist there, thereby
expressing the relationship between rows (e.g. `deliveries.medicine_id` refers to
`medicines.id`).

**3. How does `ON DELETE CASCADE` differ from `ON DELETE RESTRICT` in consequences for dependent rows, and why could different students reasonably choose different actions for the same relationship?**

`ON DELETE CASCADE` automatically deletes all dependent rows when the referenced row
is deleted; `ON DELETE RESTRICT` refuses the deletion of a referenced row while any
dependent rows still exist. The choice depends on the business semantics: whether a
dependent record should disappear together with its parent (e.g. order line items) or
must be preserved as history even if the parent is removed (e.g. a delivery ledger).
Since domains differ, two students may legitimately pick different actions for
"the same" structural link.

## How to run
```bash
sqlite3 medicines.db < script.sql
```
The intentional `FOREIGN KEY constraint failed` message in Task 4 is expected output.
