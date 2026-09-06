# Practice 19 — Creating procedures in PostgreSQL (PL/pgSQL)

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `script.sql`, `pharmacy_db_dump.sql` (db artifact), this `readme.md`.
Runs against `pharmacy_db` (schema from Practice 16, self-contained).

## Task 1 — Procedure for the atomic pair (from Practice 12)
The atomic pair that Practice 12 did manually (`BEGIN` / two statements / `COMMIT`)
is now a named procedure:
```sql
CREATE OR REPLACE PROCEDURE record_delivery(p_medicine_id INTEGER, p_supplier_id INTEGER,
    p_quantity INTEGER, p_price NUMERIC)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO deliveries (medicine_id, supplier_id, delivery_date, quantity, purchase_price)
    VALUES (p_medicine_id, p_supplier_id, CURRENT_DATE, p_quantity, p_price);
    UPDATE medicines SET stock_quantity = stock_quantity + p_quantity WHERE id = p_medicine_id;
    COMMIT;
END;
$$;
```
A procedure (not a function) is required here because the body contains `COMMIT`, which
functions are forbidden to execute (see Practice 18, Task 4).

## Task 2 — Call the procedure and verify both changes
```sql
CALL record_delivery(1, 1, 50, 20.00);   -- Paracetamol from Optima-Pharm
```
Resulting checks:
- `stock_quantity` of Paracetamol: **120 → 170** (stock raised by the delivered 50).
- `COUNT(*)` of deliveries: **20 → 21** (one new delivery row).
Both the delivery record **and** the stock change were applied by the single call.

## Task 3 — Intentional error: calling a procedure via SELECT
```sql
SELECT record_delivery(1, 1, 10, 9.00);
```
Exact PostgreSQL error + hint:
```
ERROR:  record_delivery(integer, integer, integer, numeric) is a procedure
LINE 1: SELECT record_delivery(1, 1, 10, 9.00);
               ^
HINT:  To call a procedure, use CALL.
```
A procedure is invoked with `CALL`, not by `SELECT` (which is for functions).

## Task 4 — Procedure with conditional logic (RAISE EXCEPTION)
```sql
CREATE OR REPLACE PROCEDURE record_delivery_safe(p_medicine_id, p_supplier_id, p_quantity, p_price)
...
    IF p_quantity <= 0 OR p_price < 0 THEN
        RAISE EXCEPTION 'quantity must be positive and price non-negative (got qty=%, price=%)', p_quantity, p_price;
    END IF;
    ...
```
- **Valid call:** `CALL record_delivery_safe(2, 2, 30, 33.00);` succeeded — delivery count
  went **21 → 22**.
- **Invalid call:** `CALL record_delivery_safe(3, 3, -5, 10.00);` raised:
```
ERROR:  quantity must be positive and price non-negative (got qty=-5, price=10.00)
CONTEXT:  PL/pgSQL function record_delivery_safe(integer,integer,integer,numeric) line 4 at RAISE
```

## Task 5 — Comparison with Practice 12
Practice 12 typed the manual `BEGIN` → two statements → `COMMIT` every single time a
delivery arrived (repeated in whichever application/report needed it). A named procedure
lets us write that whole unit **once** and reuse it with a one-word call (`CALL
record_delivery(...)`). What the procedure lets us **NOT repeat**: the transaction
bracketing, the two-statement logic, and the risk of forgetting a step — the application
now just says "record this delivery" and the business rule (record delivery + raise stock
+ commit atomically) is guaranteed in one place.

## Review questions and answers

**1. Why couldn't the Task 1 procedure be written as a function (Lecture 20) — what in its body excludes that?**

The body contains **`COMMIT`** (and would allow `ROLLBACK`). PostgreSQL forbids functions
from managing transactions — only procedures may execute transaction-control statements.
writing this atomic pair as a function would raise `invalid transaction termination` at
the `COMMIT` (as demonstrated in Practice 18, Task 4).

**2. What happens to the part of the procedure executed BEFORE `COMMIT` if the second part (after `COMMIT`) fails with an error?**

Because the procedure calls `COMMIT` *immediately after* its two statements, the first
part's changes become permanent before anything else runs. If a later statement failed,
the already-committed work would **remain persisted** — it would not be rolled back. So a
procedure must place `COMMIT` only at the point where the work is meant to be finalised;
any statement the author intends to be transactional together must come before it.

**3. Why is the Task 3 hint ("To call a procedure, use CALL") more useful to a developer than a generic syntax error?**

It states the *actual* rule and the corrective action in one line: the object is a
procedure, and the correct way to invoke it is `CALL`. A generic "syntax error" would
leave the developer guessing why the call was rejected; the explicit `HINT` points straight
to the fix, saving a round of debugging.

## How to run
```bash
psql -h /tmp -p 5433 -U postgres -d pharmacy_db -f script.sql
```
The two `ERROR` messages (Tasks 3 and 4's invalid call) are the expected intentional errors.
