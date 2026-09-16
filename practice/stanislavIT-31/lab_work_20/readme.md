# Practice 20 — Implementing triggers (final practice of the course)

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `script.sql`, `pharmacy_db_dump.sql` (db artifact), this `readme.md`.
Runs against `pharmacy_db` (schema from Practice 16, self-contained).
This is the capstone: from the first table in SQLite to automatic triggers in PostgreSQL
on the same schema.

## Task 1 — The log (audit) table
```sql
CREATE TABLE medicines_log (
    id         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    medicine_id INTEGER NOT NULL,
    action     TEXT NOT NULL,
    old_price  NUMERIC,
    new_price  NUMERIC,
    logged_at  TIMESTAMP DEFAULT now()
);
```
Columns: reference to the changed row (`medicine_id`), operation type (`action`), old/new
value of the tracked column, and the write time (`DEFAULT now()`).

## Task 2 — AFTER trigger for logging
```sql
CREATE FUNCTION log_medicine_price() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO medicines_log (medicine_id, action, old_price, new_price)
        VALUES (NEW.id, 'INSERT', NULL, NEW.price);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO medicines_log (medicine_id, action, old_price, new_price)
        VALUES (NEW.id, 'UPDATE', OLD.price, NEW.price);
    END IF;
    RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_medicine_price
AFTER INSERT OR UPDATE OF price ON medicines
FOR EACH ROW EXECUTE FUNCTION log_medicine_price();
```
**Test:** log count `0 → 2` after an `INSERT` (Nimesil, action INSERT, old NULL → 65.0)
and an `UPDATE` (Paracetamol 25.0 → 28.0). The log rows appeared **automatically** — no
manual INSERT into the log was written anywhere.

## Task 3 — BEFORE trigger for validation
```sql
CREATE FUNCTION check_medicine_price() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.price < 0 THEN
        RAISE EXCEPTION 'price cannot be negative (got %)', NEW.price;
    END IF;
    RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_medicine_price
BEFORE INSERT OR UPDATE OF price ON medicines
FOR EACH ROW EXECUTE FUNCTION check_medicine_price();
```

## Task 4 — Testing the blocking
`UPDATE medicines SET price = -5.0 WHERE id = 1;` raised:
```
ERROR:  price cannot be negative (got -5.0)
CONTEXT:  PL/pgSQL function check_medicine_price() line 4 at RAISE
```
Verified: the row's price **stayed 28.0** and the row **still exists** (COUNT = 1) — the
BEFORE trigger blocked the bad change before it reached the table.

## Task 5 — Final combined check of BOTH triggers together
- **(a) Successful change:** `UPDATE medicines SET price = 52.0 WHERE id = 2;` passes the
  BEFORE check (52 ≥ 0) and is immediately logged by the AFTER trigger.
- **(b) Failed attempt:** `UPDATE medicines SET price = -1.0 WHERE id = 3;` is blocked by
  the BEFORE trigger → `ERROR: price cannot be negative (got -1.0)`, so it is **NOT** logged.

Verified result, in one report:
- Log count went **2 → 3** — exactly one new log row, for the **successful** update only.
- `medicines_log` shows: id 13 (INSERT 65.0), id 1 (UPDATE 25.0→28.0), id 2 (UPDATE
  45.0→52.0). **There is no row for id 3** — the failed attempt left no trace.
- No-Spa (`id = 3`) price remains **110.0** — unchanged by the blocked attempt.

## Review questions and answers

**1. Why does the log table (Task 1) fill itself rather than being filled by a separate INSERT you would have to write in every place the main table changes?**

The trigger is attached to the main table, so **any** INSERT/UPDATE of `price` on that
table runs `log_medicine_price()` automatically — the logging is enforced at the database
level and can't be forgotten. Without a trigger, every application/module/function that
changes a medicine price would have to remember to also write a log row, and any code
path that "forgot" it would silently lose audit history.

**2. What would change in the Task 3 trigger's behaviour if `BEFORE` were replaced by `AFTER` — would the operation still be blocked?**

No. An `AFTER` trigger runs **after** the row has already been written, so `RAISE
EXCEPTION` there would roll back the just-applied change and restore the old value — the
net effect for a single statement may look similar, but it does dead work and cannot
prevent non-transactional side effects in between. A `BEFORE` trigger runs before the row
is stored and can reject it cleanly, so validation belongs in `BEFORE`.

**3. Now that you've seen both CHECK (Lecture 5) and triggers (this lecture) as ways to validate data — when should you choose a trigger over the simpler CHECK?**

A `CHECK` is best for a simple, self-contained, always-true rule about the row itself
(e.g. `price >= 0`) and runs on any DBMS. A trigger is needed when the rule involves
`NEW`/`OLD` in a way CHECK can't express, spans multiple tables or needs to run at a
specific point (`BEFORE`/`AFTER`, per-row/per-statement), or has side effects (like the
audit log in Task 2). For the simple non-negative-price rule, a `CHECK (price >= 0)`
would be the simpler, preferred option; the trigger becomes necessary for the cross-table
logging in Task 2.

## How to run
```bash
psql -h /tmp -p 5433 -U postgres -d pharmacy_db -f script.sql
```
The two `price cannot be negative` errors (Tasks 4 and 5b) are the expected intentional errors.
