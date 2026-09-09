# Лекція 20. Функції у PostgreSQL

*Подання (Лекція 19) чудово зберігають готовий `SELECT`, але не
вміщують умовну логіку — "якщо вік менше року, то 'малюк', інакше..."
не запишеш просто виразом у `WHERE`. PostgreSQL дозволяє написати
власну **функцію** мовою PL/pgSQL — з умовами, змінними й повторним
використанням, як у звичайній мові програмування, — і викликати її
прямо із SQL, наче вона вбудована.*

## 1. CREATE FUNCTION — власна функція мовою PL/pgSQL

```sql
CREATE OR REPLACE FUNCTION animal_age_in_months(age_years INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN age_years * 12;
END;
$$ LANGUAGE plpgsql;
```

`CREATE FUNCTION ім'я(параметри) RETURNS тип AS $$ ... $$ LANGUAGE
plpgsql;` — базова форма: параметри в дужках (з типами), тип
результату після `RETURNS`, тіло — між парою `$$` (заміняє лапки,
щоб не плутати з текстовими літералами всередині), мова — `plpgsql`
(процедурна мова PostgreSQL, найпоширеніша для функцій).

## 2. Викликається прямо в SELECT, як вбудована функція

```sql
SELECT name, age, animal_age_in_months(age) FROM animals;
```

Після створення власну функцію можна використовувати в `SELECT`,
`WHERE` чи будь-де в SQL так само, як `COUNT`, `strftime` чи будь-яку
іншу вбудовану функцію — перевірено: `animal_age_in_months(5)`
повертає `60`, а `SELECT ... animal_age_in_months(age) FROM animals`
обчислює значення для кожного рядка.

## 3. Умовна логіка: IF / ELSIF / ELSE

```sql
CREATE OR REPLACE FUNCTION age_category(age_years INTEGER)
RETURNS TEXT AS $$
BEGIN
    IF age_years < 1 THEN
        RETURN 'малюк';
    ELSIF age_years < 7 THEN
        RETURN 'дорослий';
    ELSE
        RETURN 'старший';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT name, age, age_category(age) FROM animals;
```

Саме тут функція виграє в порівнянні з поданням чи згенерованою
колонкою (Лекція 17): `IF`/`ELSIF`/`ELSE` дозволяє виразити
багатоваріантну логіку, яку одним виразом `CASE` теж можна б написати,
але яка стає значно читабельнішою й повторно використовуваною як
іменована функція.

## 4. Функція, що повертає ЦІЛУ таблицю рядків

```sql
CREATE OR REPLACE FUNCTION animals_by_species(p_species TEXT)
RETURNS TABLE(id INTEGER, name TEXT, age INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT a.id, a.name, a.age FROM animals a WHERE a.species = p_species;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM animals_by_species('кіт');
```

Функція не обов'язково повертає одне число чи рядок — `RETURNS
TABLE(колонки)` разом із `RETURN QUERY` дозволяє повернути ЦІЛИЙ
набір рядків, і викликати таку функцію можна прямо в `FROM`, як
звичайну таблицю чи подання — перевірено: результат — саме ті рядки,
що відповідають параметру.

## 5. Пастка: функція НЕ може сама керувати транзакцією

```sql
CREATE OR REPLACE FUNCTION bad_func() RETURNS VOID AS $$
BEGIN
    UPDATE animals SET status = 'x';
    COMMIT;
END;
$$ LANGUAGE plpgsql;

SELECT bad_func();
```

```text
ERROR: invalid transaction termination
CONTEXT: PL/pgSQL function bad_func() line 4 at COMMIT
```

Функція виконується ВСЕРЕДИНІ транзакції того, хто її викликав
(Лекція 14) — вона не може сама зробити `COMMIT` чи `ROLLBACK`;
помилка виникає саме в момент виклику (перевірено), а не при
створенні функції. Якщо потрібна логіка, що сама фіксує зміни
частинами, — для цього в PostgreSQL є окремий вид об'єкта, **процедура**
(Лекція 21).

## Підсумок

- `CREATE FUNCTION ім'я(параметри) RETURNS тип AS $$ ... $$ LANGUAGE
  plpgsql;` — власна функція, яку можна викликати прямо в SQL, як
  вбудовану.
- `IF`/`ELSIF`/`ELSE` усередині функції дозволяє умовну логіку, яку
  не можна виразити одним SQL-виразом.
- `RETURNS TABLE(...)` + `RETURN QUERY` дозволяє функції повернути
  цілий набір рядків, а не одне значення.
- Функція не може сама викликати `COMMIT`/`ROLLBACK` — вона завжди
  виконується в межах транзакції викликача; помилка "invalid
  transaction termination" виникає саме при спробі це зробити.

**Практика до цієї лекції:** [Практика 18. Написання функцій у PostgreSQL](../practice/18-functions.md)
