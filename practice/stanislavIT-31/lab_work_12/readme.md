# Practice 12 — Creating and rolling back transactions in SQLite

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `medicines.db`, `script.sql`, this `readme.md`.

## Task 1 — Atomic pair: INSERT + UPDATE in one transaction
```sql
BEGIN;
INSERT INTO deliveries (medicine_id, supplier_id, delivery_date, quantity, purchase_price)
VALUES (1, 1, '2026-01-20', 60, 22.00);
UPDATE medicines SET stock_quantity = stock_quantity + 60 WHERE id = 1;
COMMIT;
```
Verified: delivery count **12 → 13** and Paracetamol stock **120 → 180** (both present).
**Why these two changes must run TOGETHER:** recording the delivery in `deliveries` and
raising the stock counter in `medicines` describe the *same* business event. If they ran
as two independent operations and the process failed in between, the database would be
inconsistent — either a delivery record with no corresponding stock increase, or stock
that rose without a delivery to explain it. A single transaction makes both happen or neither.

## Task 2 — Conscious ROLLBACK
```sql
BEGIN;
INSERT INTO deliveries (... '2026-02-01' ...);
UPDATE medicines SET stock_quantity = stock_quantity - 10 WHERE id = 2;
ROLLBACK;
```
Verified: count stays **13**, Ibuprofen stock stays **90**, and the inserted row
(`delivery_date = '2026-02-01'`) is **absent** — the data is exactly as it was before
`BEGIN`. ROLLBACK fully cancelled both changes.

## Task 3 — Intermediate state inside the transaction
Inside a `BEGIN` (before `COMMIT`/`ROLLBACK`), a `SELECT` showed the just-inserted row:
count **14** while open, then back to **13** after `ROLLBACK`.
**Why this is not a contradiction with atomicity:** within the *same session*, our own
uncommitted changes are visible to us (the transaction holds the lock and sees its own
writes). "Not yet final" refers to *other sessions* and to durability — until `COMMIT`
another connection cannot see these rows, and a crash would discard them.

## Task 4 — Intentional error inside the transaction
```sql
BEGIN;
INSERT INTO deliveries (... '2026-03-01' ...);
UPDATE deliveries SET quantity = NULL WHERE medicine_id = 7 AND delivery_date = '2026-03-01';
```
Exact SQLite error:
```
Error near line 143: NOT NULL constraint failed: deliveries.quantity
```
While the transaction was **still open**, the check query showed the first, successful
`INSERT` was **still present** (count **14**, the row counted) — the error did not
automatically undo it. Then `ROLLBACK` was issued and both the failed attempt and the
inserted row were removed (count back to **13**).

## Task 5 — Forgotten ROLLBACK (COMMIT after the error)
Same scenario (successful insert + failing `UPDATE`), but this time `COMMIT` instead of
`ROLLBACK`:
```
Error near line 161: NOT NULL constraint failed: deliveries.quantity
```
After `COMMIT`, count is **14** and the inserted row
(`delivery_date = '2026-03-15'`) is **present** — the successful `INSERT` was committed,
while the failing `UPDATE` was not applied.
**Why the result is "first change is present, second absent" and not "nothing applied" or
"both applied":** the error aborted only the *failing statement*; the transaction itself
remained open with the earlier successful statement as a pending change. `COMMIT` then
persisted whatever had succeeded and discarded nothing that had succeeded, while the
failed statement's effect never existed. **This is dangerous for a developer** who assumes
"the transaction did not pass because of the error" — unless they explicitly `ROLLBACK`,
the successful part silently gets committed.

## Justification for the choices in Task 5
With an error inside a transaction, PostgreSQL "cannot run in a transaction block" and
the whole batch is rolled back, whereas SQLite leaves the transaction open after the
error. This is exactly why a developer must explicitly `ROLLBACK` after an error — relying
on the error to clean up is unsafe.

## Review questions and answers

**1. In Task 1 — what would go wrong if the two changes ran as two separate, unrelated transactions and a failure happened between them?**

If the `INSERT` transaction committed but the `UPDATE` transaction then failed, the
database would contain a delivery record that did not increase the stock — the delivered
goods would be "lost" on the shelf. If the reverse happened, stock would rise with no
delivery record to account for it. Either way the data becomes internally inconsistent.

**2. Why in Task 5 is the result after COMMIT exactly "first change present, second absent" rather than "nothing applied" or "both applied"?**

The constraint error aborts only that one failing statement, not the whole open
transaction. The successful `INSERT` remains a valid pending change; when `COMMIT` runs,
it persists every successfully executed statement of the transaction and the failed
statement simply leaves no trace — so exactly the successful part is applied.

**3. Which ACID property does the Task 2 ROLLBACK result demonstrate, and which does the Task 5 partial-commit result demonstrate?**

Task 2 (`ROLLBACK` fully discards the changes) demonstrates **Atomicity** — the
transaction's changes are all-or-nothing. Task 5 (only the successfully executed
statements affect the final state) demonstrates that the DBMS honors **atomicity only
through explicit control** — the granularity of what "succeeds" is per-statement, so
without a `ROLLBACK` the commit granularity is per-statement too. (Durability is shown by
`COMMIT` persisting changes, Consistency by constraint checks.)

## How to run
```bash
sqlite3 medicines.db < script.sql
```
The two `NOT NULL constraint failed` messages (Tasks 4 and 5) are expected intentional errors.
