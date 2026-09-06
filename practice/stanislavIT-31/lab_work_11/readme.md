# Practice 11 — Formatting queries with printf() and dates

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `medicines.db`, `script.sql`, this `readme.md`.

## Task 1 — printf() on a number
```sql
SELECT id, purchase_price AS raw_price,
       printf('%.2f UAH', purchase_price) AS formatted_price
FROM deliveries WHERE purchase_price IS NOT NULL ORDER BY id;
```
Raw values like `85.85`, `33.7`, `48.3` become `85.85 UAH`, `33.70 UAH`, `48.30 UAH`.
**Difference for a report reader:** the raw value may drop trailing zeros (`33.7`) and
carries no unit, so it is ambiguous; the formatted value always shows exactly two decimal
places and an explicit currency, which is instantly readable in a printed report.

## Task 2 — printf() with alignment
```sql
SELECT printf('Delivery #%03d', id) AS label,
       printf('%5d units', quantity) AS qty_align FROM deliveries ORDER BY id;
```
`%03d` zero-pads the id (`Delivery #001`) and `%5d` right-aligns to a width of 5
(`   76 units`). **Purpose of width alignment:** even in a monospaced CLI/SQL output,
fixed widths make columns line up vertically so values are easy to scan and compare;
`%03d` also gives ids a stable sort-friendly length. This matters even in a table for
readability and for aligning multi-row dumps.

## Task 3 — Shifting a date relative to an existing one
```sql
SELECT id, delivery_date, date(delivery_date, '+30 days') AS payment_deadline
FROM deliveries ORDER BY id;
```
e.g. delivery on `2025-09-01` → payment deadline `2025-10-01`.
**Practical sense in this variant:** the pharmacy's invoice for a delivery is usually
due within 30 days; this query answers "by which date must each invoice be settled to
keep the early-payment discount / avoid a penalty" without storing derived dates.

## Task 4 — strftime() and GROUP BY by year / month
```sql
SELECT strftime('%Y', delivery_date) AS yr, COUNT(*) AS deliveries_count
FROM deliveries GROUP BY yr ORDER BY yr;          -- 2024: 3, 2025: 9
SELECT strftime('%Y', ...), strftime('%m', ...), COUNT(*) ... GROUP BY yr, mo;
```
**Why grouping by the strftime() result and not directly by the full date column:**
grouping by the full `delivery_date` would make a separate group for every distinct
date (12 groups), while we want aggregates over calendar periods. `strftime('%Y', date)`
reduces each date to its year, so all deliveries of the same year fall into one group —
the grouping key must be the *derived period*, not the full timestamp.

## Task 5 — Intentional error: strftime() on a non-date string
```sql
SELECT 'not-a-date', strftime('%Y', 'not-a-date'), date('not-a-date');
```
SQLite returns **`NULL`** for both `strftime(...)` and `date(...)` — **no error, no
exception**. It silently treats the input as unparseable and yields `NULL`.
**Why this cannot be relied on as "automatic validation":** the function neither raises
nor flags the bad input; the `NULL` looks identical to a legitimate missing/empty value.
So a typo in a date column would quietly poison the result of any aggregate or WHERE
query. For robust date checks a real `CHECK` constraint with proper validation is needed,
not silent function behaviour.

## Review questions and answers

**1. How does printf() for formatting output differ from changing the stored value — does the column change physically after a printf() query?**

`printf()` only affects the **displayed output** of the query — it computes a derived
string in the result set and returns it without touching the table. The stored column
value in the database file remains exactly as it was; the next plain `SELECT` shows the
original raw number again.

**2. Why does strftime('%Y', column) return the year as TEXT, not a number, and when can that matter?**

SQLite is dynamically typed and `strftime()` always returns a **text** string (SQLite has
no dedicated DATE type — dates are TEXT/REAL/INTEGER). The year `'2025'` is produced as
text. This matters when comparing or sorting: text ordering puts `'2025'` before `'2026'`
if the strings are equal length, but mixing formats (e.g. `'9'` vs `'10'`) would sort
lexicographically wrong — so a numeric cast or zero-padded text is needed.

**3. What does the Task 5 conclusion mean for writing CHECK constraints on date columns?**

Since date functions quietly return `NULL` on bad input instead of erroring, a `CHECK`
that only calls `date(col)` would never fail — it would just store `NULL`-based results.
Therefore validating dates requires an explicit check that the parsed value is not `NULL`
and equals the original (e.g. `CHECK (date(col) IS NOT NULL AND date(col) = col)`), not
relying on the function to reject bad dates automatically.

## How to run
```bash
sqlite3 medicines.db < script.sql
```
