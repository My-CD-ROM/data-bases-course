# Практика 8. Агрегатні функції

**Варіант:** Бібліотека
**База даних:** `lab_work3.db`
**Таблиці:** `books` (каталог книг), `loans` (журнал видач), `readers` (читачі)

**Мета заняття:** застосувати `COUNT`, `SUM`, `AVG`, `MIN`, `MAX` до фактової (`loans`) та таблиць-вимірів (`books`, `readers`) без зміни структури, і на практиці переконатися, як `NULL` впливає на результат кожної агрегатної функції.

---

## Структура таблиць (з `PRAGMA table_info`)

**`loans`** — фактова (журнальна) таблиця:

| cid | name | type | notnull | pk |
|---|---|---|---|---|
| 0 | id | INTEGER | 0 | 1 |
| 1 | book_id | INTEGER | 1 | 0 |
| 2 | reader_id | INTEGER | 1 | 0 |
| 3 | loan_date | TEXT | 0 | 0 |
| 4 | return_date | TEXT | 0 | 0 |

**`books`** — вимір:

| cid | name | type | notnull | pk |
|---|---|---|---|---|
| 0 | id | INTEGER | 0 | 1 |
| 1 | title | TEXT | … | 0 |
| 2 | author | TEXT | … | 0 |
| 3 | publication_year | INTEGER | … | 0 |
| 4 | genre | TEXT | … | 0 |
| 5 | copies_count | INTEGER | … | 0 |

**`readers`** — вимір:

| cid | name | type | notnull | pk |
|---|---|---|---|---|
| 0 | id | INTEGER | 0 | 1 |
| 1 | last_name | TEXT | 1 | 0 |
| 2 | first_name | TEXT | 1 | 0 |
| 3 | email | TEXT | 0 | 0 |
| 4 | registration_date | TEXT | 1 | 0 |

Колонка `return_date` у `loans` — «необов'язкова дата завершення», саме вона використовується в Завданні 1.

---

## Завдання 1. `COUNT(*)` проти `COUNT(колонка)`

### 1.1. Загальна кількість позик

```sql
SELECT COUNT(*) FROM loans;