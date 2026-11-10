# Лекція 21. Процедури у PostgreSQL

*Лекція 20 закінчилась пасткою: функція не може сама зробити `COMMIT`
чи `ROLLBACK` — вона завжди виконується всередині транзакції
викликача. Але іноді потрібно саме це: іменований, повторно
використовуваний блок логіки (як атомарна транзакція з Лекції 14), що
сам вирішує, коли зафіксувати зміни. Для цього в PostgreSQL є окремий
вид об'єкта — **процедура**.*

## 1. CREATE PROCEDURE — без RETURNS

```sql
CREATE OR REPLACE PROCEDURE mark_animal_status(p_id INTEGER, p_status TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE animals SET status = p_status WHERE id = p_id;
END;
$$;
```

Синтаксично процедура схожа на функцію (Лекція 20), але без
`RETURNS` — процедура не повертає значення як результат виразу.
Параметри в дужках так само з типами; тіло — так само між `$$`.

## 2. Викликається через CALL, не SELECT

```sql
CALL mark_animal_status(1, 'вибув');
```

```sql
SELECT mark_animal_status(1, 'x');
```

```text
ERROR: mark_animal_status(integer, unknown) is a procedure
HINT: To call a procedure, use CALL.
```

Процедуру НЕ можна викликати через `SELECT`, як функцію — потрібна
окрема команда `CALL` (перевірено: спроба `SELECT` завершується
помилкою з чіткою підказкою). Це не довільне обмеження синтаксису — це
відображає принципову різницю: процедура не є виразом, що повертає
значення для використання в запиті, а самостійною дією.

## 3. Головна причина існування процедур: внутрішній COMMIT

```sql
CREATE OR REPLACE PROCEDURE bulk_mark_all_active()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE animals SET status = 'на обліку' WHERE status IS DISTINCT FROM 'на обліку';
    COMMIT;
    RAISE NOTICE 'Оновлено і зафіксовано';
END;
$$;

CALL bulk_mark_all_active();
```

На відміну від функції (Лекція 20, розділ 5), процедура МОЖЕ містити
`COMMIT` (і `ROLLBACK`) прямо у своєму тілі — перевірено: виклик
успішно виконався й зафіксував зміни. Це особливо корисно для
процедур, що обробляють великий обсяг даних частинами: кожна частина
може фіксуватись окремо, не чекаючи завершення всієї процедури.

## 4. Function проти Procedure — підсумкове порівняння

| | Function (Лекція 20) | Procedure |
|---|---|---|
| Оголошення | `RETURNS тип` | без `RETURNS` |
| Виклик | `SELECT func(...)` | `CALL proc(...)` |
| Повертає значення для запиту | так | ні |
| `COMMIT`/`ROLLBACK` усередині | заборонено (помилка) | дозволено |
| Типове призначення | обчислення, що використовується в SQL-запиті | самостійна дія / послідовність змін |

## 5. Практичний шаблон: атомарна пара як процедура

```sql
CREATE OR REPLACE PROCEDURE sell_car(p_car_id INTEGER, p_client_id INTEGER, p_price NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO sales (car_id, client_id, sale_date, sale_price)
    VALUES (p_car_id, p_client_id, CURRENT_DATE, p_price);

    UPDATE cars SET status = 'продано' WHERE id = p_car_id;

    COMMIT;
END;
$$;

CALL sell_car(5, 3, 980000);
```

Це — та сама атомарна пара `INSERT` + `UPDATE` з Лекції 14, тепер
оформлена як іменована, повторно використовувана процедура: замість
того, щоб щоразу вручну писати `BEGIN`/два запити/`COMMIT`, достатньо
одного виклику `CALL sell_car(...)`.

## Підсумок

- `CREATE PROCEDURE ім'я(параметри) LANGUAGE plpgsql AS $$ ... $$;` —
  без `RETURNS`; викликається через `CALL`, а не `SELECT`.
- Спроба викликати процедуру через `SELECT` завершується чіткою
  помилкою з підказкою використати `CALL`.
- На відміну від функції, процедура МОЖЕ містити `COMMIT`/`ROLLBACK`
  усередині свого тіла — це і є головна причина, чому процедури
  існують окремо від функцій.
- Атомарну пару пов'язаних змін (Лекція 14) зручно оформити як
  процедуру — повторно використовуваний виклик замість ручного
  `BEGIN`/`COMMIT` щоразу.

**Практика до цієї лекції:** [Практика 19. Створення процедур у PostgreSQL](../practice/19-procedures.md)
