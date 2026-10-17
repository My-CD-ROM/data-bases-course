# Practice 16 — Creating a database in PostgreSQL (PgAdmin / psql)

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `script.sql` (the translated CREATE TABLE + data load),
`pharmacy_db_dump.sql` (database dump = the `db` artifact), this `readme.md`.

The database was created in PostgreSQL as **`pharmacy_db`** (port 5433).

## Task 1 — Create the database
`pharmacy_db` was created in PgAdmin (right-click server → Create → Database), named
after the variant.

## Task 2 — The three translated CREATE TABLE
The full three-table schema was translated from SQLite to PostgreSQL:

| Difference applied | SQLite | PostgreSQL |
|---|---|---|
| Auto-increment | `id INTEGER PRIMARY KEY` | `id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY` |
| Decimal prices | `REAL` | `NUMERIC` (exact for money) |
| Dates | `TEXT` | `DATE` |
| FK enforcement | needs `PRAGMA foreign_keys = ON;` per connection | enforced **natively**, no PRAGMA |

```sql
CREATE TABLE medicines  (id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL, manufacturer TEXT, form TEXT,
    price NUMERIC NOT NULL, stock_quantity INTEGER NOT NULL DEFAULT 0);
CREATE TABLE suppliers  (id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL, contact_person TEXT, phone TEXT, city TEXT);
CREATE TABLE deliveries (id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    medicine_id INTEGER NOT NULL REFERENCES medicines(id) ON DELETE RESTRICT,
    supplier_id INTEGER NOT NULL REFERENCES suppliers(id) ON DELETE RESTRICT,
    delivery_date DATE NOT NULL, quantity INTEGER NOT NULL, purchase_price NUMERIC);
```

## Task 3 — Data migration
The data from the SQLite labs was loaded preserving the original ids. Because the
columns are `GENERATED ALWAYS AS IDENTITY`, explicit ids required
`OVERRIDING SYSTEM VALUE` (the PgAdmin CSV import writes ids the same way). The order
matters: the two dimension tables were populated **before** the fact table, so every
foreign key already had its referenced row.

## Task 4 — Fixing the id counters (setval)
```sql
SELECT setval(pg_get_serial_sequence('medicines',  'id'), (SELECT MAX(id) FROM medicines));   -- 12
SELECT setval(pg_get_serial_sequence('suppliers',  'id'), (SELECT MAX(id) FROM suppliers));   -- 12
SELECT setval(pg_get_serial_sequence('deliveries', 'id'), (SELECT MAX(id) FROM deliveries));  -- 20
```
Proof that the counter continues correctly: `INSERT` of a new medicine without an
explicit id returned **id = 13** — it did **not** repeat the already-used value 12.

## Task 5 — Integrity check + intentional FK error
Counts in PostgreSQL (matching SQLite): **medicines = 13**, **suppliers = 12**,
**deliveries = 20**.
Intentional FK error, exact PostgreSQL message:
```
ERROR:  insert or update on table "deliveries" violates foreign key constraint
        "deliveries_medicine_id_fkey"
DETAIL:  Key (medicine_id)=(9999) is not present in table "medicines".
```

## Review questions and answers

**1. Why choose `GENERATED ALWAYS AS IDENTITY` over the older `SERIAL`, and how do they differ in essence?**

`SERIAL` is a convenience that creates an `INTEGER` column with a default from an
implicit sequence — it is not a true identity; the default can be overridden, and audit
can't tell "user-provided" from "generated". `GENERATED ALWAYS AS IDENTITY` is a real
SQL-standard identity column: PostgreSQL forbids an explicit non-value insert unless you
explicitly ask (`OVERRIDING SYSTEM VALUE`), giving stronger protection against accidental
manual ids. This course prefers IDENTITY for that correctness.

**2. Why must the dimension tables be created and filled BEFORE the fact table, not in arbitrary order?**

The fact table's foreign keys reference the dimension tables. `CREATE TABLE` on the fact
table fails if the referenced tables don't exist yet, and inserting a fact row fails if
its referenced dimension row isn't already present. Populating dimensions first guarantees
every FK finds its target, so the load order is not arbitrary but mandatory.

**3. What would happen if Task 4 (fixing the counter) were skipped — at which step would it surface as an error?**

The identity sequence would still be at its initial value (e.g. 1). The first `INSERT`
without an explicit id would then try id **1** (or the next low value),
**colliding with an existing row and raising a unique-violation error** on the primary
key. So after importing rows with explicit high ids, forgetting `setval` produces a
duplicate-key failure at the very next insert.

## How to run
```bash
# Point psql at the running server, then run the script:
psql -h /tmp -p 5433 -U postgres -d pharmacy_db -f script.sql
# Restore the database dump (the db artifact):
psql -h /tmp -p 5433 -U postgres -d pharmacy_db -f pharmacy_db_dump.sql
```
