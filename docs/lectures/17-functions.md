# Лекція 17. Функції у PostgreSQL

*Подання (лекція 16) зберігає в базі готовий запит. Але часто потрібно
зберегти не запит, а обчислення: вікову групу тварини, суму замовлення,
підсумок про власника, – і підставляти його в будь-який запит, ще й з
різними вхідними значеннями. Вираз `CASE` для цього доводиться
повторювати в кожному запиті, а подання не приймає параметрів.
PostgreSQL дозволяє написати власну **функцію** мовою PL/pgSQL (з
умовами, змінними й обробкою помилок) і викликати її прямо в SQL, як
вбудовану.*

Приклади лекції виконуються на базі ветклініки, щойно завантаженій з
файлу [`vet_clinic_demo.sql`](../practice/sql/22-procedures/vet_clinic_demo.sql)
(з ним ви працюватимете й у практиці 22): троє власників і чотири тварини – коти
Мурка (3 роки) і Барсик (5) у Петренко, пес Рекс (7) у Коваля, хом’як
Пушок (1) у Мельник; у всіх тварин `status` – «на обліку». Потрібні лише таблиці `owners` і `animals`.

## 1. CREATE FUNCTION: власна функція мовою PL/pgSQL

```sql
CREATE OR REPLACE FUNCTION animal_age_in_months(age_years INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN age_years * 12;
END;
$$ LANGUAGE plpgsql;
```

Будова функції:

- `CREATE OR REPLACE FUNCTION` – створити функцію, а якщо функція з такою
  назвою і такими типами параметрів уже є, замінити її;
- у дужках після назви – параметри з типами: вхідні значення, які функція
  отримує під час виклику;
- `RETURNS INTEGER` – тип результату;
- тіло стоїть між двома `$$`: це заміна лапок, тому лапки всередині тіла
  (`'малюк'`) не треба подвоювати;
- у тілі – блок `BEGIN … END;`, а команда `RETURN` повертає результат і
  завершує функцію;
- `LANGUAGE plpgsql` – мова, якою написано тіло.

> **PL/pgSQL** – процедурна мова PostgreSQL: SQL, до якого додано
> змінні, умови, цикли й обробку помилок.

> **Збережена функція** – іменований фрагмент коду, який зберігається в
> базі даних, приймає параметри, повертає результат і викликається в
> SQL-запиті так само, як вбудована функція.

Для `NULL` функція поверне `NULL`: арифметика з `NULL` дає `NULL`, помилки
немає.

## 2. Виклик прямо в SELECT, як вбудованої функції

```sql
SELECT animal_age_in_months(5);
SELECT name, age, animal_age_in_months(age) AS months FROM animals;
```

```text
 animal_age_in_months
----------------------
                   60

  name  | age | months
--------+-----+--------
 Мурка  |   3 |     36
 Барсик |   5 |     60
 Рекс   |   7 |     84
 Пушок  |   1 |     12
```

Власну функцію використовують у `SELECT`, `WHERE`, `ORDER BY`,
`GROUP BY` так само, як `upper` чи `ROUND`. У списку `SELECT` вона
викликається окремо для кожного рядка. Цим вона відрізняється від
`COUNT`: `COUNT` – агрегатна функція, що згортає всі рядки в одне
значення, а наша функція скалярна – одне значення на кожен рядок.

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

```text
  name  | age | age_category
--------+-----+--------------
 Мурка  |   3 | дорослий
 Барсик |   5 | дорослий
 Рекс   |   7 | старший
 Пушок  |   1 | дорослий
```

Умови перевіряються згори вниз, і виконується перша істинна гілка;
`RETURN` одразу завершує функцію. Тому друга умова – просто
`age_years < 7`: до неї доходять лише значення, для яких перша вже
хибна. Рекс (рівно 7) – «старший», бо 7 не менше 7. Межі гілок
перевіряйте саме на граничних значеннях.

**Кожен шлях має дійти до RETURN.** Функцію без гілки `ELSE` PostgreSQL
створює без помилок, і на наших тваринах вона працює:

```sql
CREATE FUNCTION age_group(age_years INTEGER) RETURNS TEXT AS $$
BEGIN
    IF age_years >= 7 THEN RETURN 'старший';
    ELSIF age_years >= 1 THEN RETURN 'дорослий';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT age_group(0);
```

```text
ERROR:  control reached end of function without RETURN
CONTEXT:  PL/pgSQL function age_group(integer)
```

Для 0 (і для `NULL`) жодна умова не істинна, виконання доходить до `END`
без `RETURN`. Помилка з’являється лише під час виклику з таким
значенням, тому найпростіше завжди писати гілку `ELSE`.

**Вираз CASE – умова прямо в запиті.** Таку саму класифікацію можна
записати без функції, звичайним SQL. Для цього є вираз `CASE`:

```sql
SELECT name, age,
       CASE WHEN age < 1 THEN 'малюк'
            WHEN age < 7 THEN 'дорослий'
            ELSE 'старший'
       END AS age_category
FROM animals;
```

```text
  name  | age | age_category
--------+-----+--------------
 Мурка  |   3 | дорослий
 Барсик |   5 | дорослий
 Рекс   |   7 | старший
 Пушок  |   1 | дорослий
```

Читається так: «у випадку, коли (`WHEN`) умова істинна, тоді (`THEN`)
таке значення». Як працює `CASE`:

- умови `WHEN` перевіряються згори вниз, і вираз повертає значення
  `THEN` **першої** істинної умови, решту вже не перевіряє;
- якщо жодна умова не істинна, повертається значення після `ELSE`;
- якщо `ELSE` немає, результат – `NULL` (помилки, як у функції без
  `ELSE`, не буде): `CASE WHEN 0 >= 7 THEN 'старший' WHEN 0 >= 1 THEN
  'дорослий' END` дає `NULL`;
- вираз закінчується словом `END`, а `AS` дає колонці назву;
- усі гілки мають повертати значення одного типу: `CASE WHEN … THEN 1
  ELSE 'x' END` дає `ERROR:  invalid input syntax for type integer: "x"`.

Пастка з `NULL` та сама, що й в `IF` (розділ 7): для невідомого віку
умова `age < 1` не істинна, і `CASE` поверне «старший». Якщо `NULL`
можливий, перевіряйте його першою умовою: `WHEN age IS NULL THEN
'вік невідомий'`.

Є й коротка форма, коли одну колонку порівнюють з кількома значеннями:

```sql
SELECT name, species,
       CASE species WHEN 'кіт'    THEN 'котячі'
                    WHEN 'собака' THEN 'собачі'
                    ELSE 'інші'
       END AS family
FROM animals;
```

```text
  name  | species | family
--------+---------+--------
 Мурка  | кіт     | котячі
 Барсик | кіт     | котячі
 Рекс   | собака  | собачі
 Пушок  | хом'як  | інші
```

**Де можна використовувати CASE.** `CASE` – це вираз, тобто він дає
одне значення, тому його можна писати всюди, де SQL чекає значення:

- у `SELECT` – нова обчислена колонка, як вище;
- у `WHERE` – умова відбору:
  `WHERE CASE WHEN age < 1 THEN 'малюк' WHEN age < 7 THEN 'дорослий'
  ELSE 'старший' END = 'дорослий'` поверне Мурку, Барсика і Пушка;
- у `GROUP BY` – групування за обчисленою категорією:

  ```sql
  SELECT CASE WHEN age < 1 THEN 'малюк'
              WHEN age < 7 THEN 'дорослий'
              ELSE 'старший'
         END AS age_category,
         COUNT(*) AS cnt
  FROM animals
  GROUP BY 1
  ORDER BY 1;
  ```

  ```text
   age_category | cnt
  --------------+-----
   дорослий     |   3
   старший      |   1
  ```

  (`GROUP BY 1` і `ORDER BY 1` – групувати й сортувати за першою колонкою
  списку `SELECT`, щоб не повторювати весь `CASE`);
- в `ORDER BY` – власний порядок сортування, не за абеткою: спершу
  собаки, потім коти, потім решта:
  `ORDER BY CASE species WHEN 'собака' THEN 1 WHEN 'кіт' THEN 2 ELSE 3 END, name`;
- в `UPDATE … SET` – різне нове значення для різних рядків, наприклад
  `SET status = CASE WHEN age >= 15 THEN 'на спостереженні' ELSE status END`;
- у згенерованому стовпці (лекція 14):
  `GENERATED ALWAYS AS (CASE … END) STORED`.

`CASE` – частина стандарту SQL, тож так само він працює і в SQLite.

**CASE чи IF.** `IF … ELSIF … ELSE` – це команда мови PL/pgSQL: її пишуть
лише в тілі функції чи процедури, і вона керує тим, які команди
виконувати далі. `CASE` – вираз SQL: його пишуть у будь-якому запиті,
і він лише обчислює значення.

**CASE чи функція.** `CASE` доведеться повторювати в кожному запиті, де
потрібна вікова група. Якщо межу груп змінять з 7 на 8 років, правити
доведеться всі ці запити, і досить пропустити один, щоб різні звіти
показували різне. Функцію `age_category` правлять один раз, і всі запити,
що її викликають, одразу отримують нову межу.

**Згенерований стовпець чи функція.** Згенерований стовпець
(лекція 14) теж може містити `CASE`
(`GENERATED ALWAYS AS (CASE … END) STORED`), але обчислюється лише з колонок
того самого рядка, не приймає параметрів і не бачить інших таблиць. Нашу
функцію в ньому використати не можна:
`ERROR:  generation expression is not immutable` (причина – у розділі 8).
Функція ж приймає будь-які параметри, може читати інші таблиці, зберігати
проміжні значення у змінних і зупинятися з помилкою (розділ 6). Зате
стовпець `STORED` рахується один раз під час запису, і на ньому можна
побудувати індекс (у PostgreSQL 18 без слова `STORED` стовпець
віртуальний: рахується під час читання), а функція рахує щоразу під час запиту.

## 4. Функція, що повертає таблицю

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

```text
 id |  name  | age
----+--------+-----
  1 | Мурка  |   3
  2 | Барсик |   5
```

Після `RETURNS` стоїть `TABLE(…)` з колонками результату і їхніми
типами, а в тілі – `RETURN QUERY` і запит, усі рядки якого стають
результатом.

> **Функція, що повертає таблицю**, – функція, оголошена з
> `RETURNS TABLE(колонки)`, яка повертає набір рядків; її викликають у
> `FROM`, як таблицю чи подання.

Результат збігається з прямим запитом
`SELECT id, name, age FROM animals WHERE species = 'кіт'` – так таку
функцію й перевіряють. До її результату можна дописати `WHERE`,
`ORDER BY`, `JOIN`: `SELECT name FROM animals_by_species('кіт') WHERE age > 3`
поверне лише Барсика. Без `FROM` (`SELECT animals_by_species('кіт')`)
кожен рядок приходить однією колонкою-записом: `(1,Мурка,3)`.

**Псевдоніми обов’язкові.** Колонки з `RETURNS TABLE` усередині функції
теж стають змінними. Якщо в запиті написати `SELECT id, name, age FROM
animals WHERE species = p_species`, функція створиться, а виклик дасть:

```text
ERROR:  column reference "id" is ambiguous
DETAIL:  It could refer to either a PL/pgSQL variable or a table column.
```

Тому в `RETURN QUERY` таблиці дають псевдонім (`a`) і пишуть усі колонки
через нього: `a.id`, `a.name`.

**Типи мають збігатися точно.** `RETURN QUERY` нічого не приводить сам:

```sql
CREATE FUNCTION species_stats()
RETURNS TABLE(species TEXT, cnt INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT a.species, COUNT(*) FROM animals a GROUP BY a.species;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM species_stats();
```

```text
ERROR:  structure of query does not match function result type
DETAIL:  Returned type bigint does not match expected type integer in column "cnt" (position 2).
```

`COUNT(*)` повертає `BIGINT`. Виправлення – оголосити `cnt BIGINT` або
привести тип у запиті: `COUNT(*)::INTEGER` (запис `::тип` перетворює
значення на вказаний тип). Після цього функція повертає
`кіт | 2`, `собака | 1`, `хом'як | 1`. Так само падають пари `real` і
`numeric`, `character varying(50)` і `text`: тип у `RETURNS TABLE`
беріть такий самий, як у колонці таблиці.

**RETURN замість RETURN QUERY** – помилка вже під час `CREATE FUNCTION`:

```text
ERROR:  RETURN cannot have a parameter in function returning set
HINT:  Use RETURN NEXT or RETURN QUERY.
```

**Функція чи подання.** Обидва – збережений `SELECT`, який викликають у
`FROM`. Подання не має параметрів: на кожен вид потрібне окреме подання
або `WHERE` у кожному запиті. Функцію з `RETURNS TABLE` без параметрів
можна використати замість подання, а функцію з параметром подання не
замінить. Зате через просте подання можна змінювати дані (лекція 16,
розділ 3), а через функцію з `RETURNS TABLE` – ні.

## 5. Пастка: функція не може сама керувати транзакцією

```sql
CREATE OR REPLACE FUNCTION bad_func() RETURNS VOID AS $$
BEGIN
    UPDATE animals SET status = 'вибув';
    COMMIT;
END;
$$ LANGUAGE plpgsql;

SELECT bad_func();
```

```text
ERROR:  invalid transaction termination
CONTEXT:  PL/pgSQL function bad_func() line 4 at COMMIT
```

`CREATE FUNCTION` проходить без помилки, а виклик падає. Після помилки
`status` у всіх тварин – досі «на обліку»: `UPDATE` скасовано разом із
запитом. (`RETURNS VOID` означає, що функція нічого не повертає, лише
виконує дію.)

**Чому помилка лише під час виклику.** Під час `CREATE FUNCTION`
PostgreSQL перевіряє синтаксис тіла: функцію з `RETRN 1;` замість
`RETURN 1;` не буде створено (`ERROR:  syntax error at or near "RETRN"`).
Але команда `COMMIT` синтаксично допустима: її використовують процедури.
Чи можна її виконати, залежить від контексту виконання. Функцію завжди
викликають із запиту (`SELECT bad_func()`), а запит виконується
всередині транзакції – явної, після `BEGIN`, або неявної, яку PostgreSQL
відкриває на один запит (лекція 12). Функція – частина цього запиту і не
може завершити транзакцію, яку відкрила не вона.

**Помилка скасовує весь запит.** З тієї самої причини помилка у функції
скасовує всі зміни запиту, зокрема й для рядків, оброблених до неї:

```sql
CREATE FUNCTION set_age(p_id INTEGER, p_age INTEGER)
RETURNS VOID AS $$
BEGIN
    IF p_age < 0 THEN
        RAISE EXCEPTION 'Від''ємний вік: %', p_age;
    END IF;
    UPDATE animals SET age = p_age WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;

SELECT set_age(id, age - 2) FROM animals;
SELECT name, age FROM animals ORDER BY id;
```

```text
ERROR:  Від'ємний вік: -1
CONTEXT:  PL/pgSQL function set_age(integer,integer) line 4 at RAISE

  name  | age
--------+-----
 Мурка  |   3
 Барсик |   5
 Рекс   |   7
 Пушок  |   1
```

Для Мурки, Барсика й Рекса попередні виклики вже виконали `UPDATE`, але на
Пушку (1 – 2 = –1) функція зупинилася, і вік не змінився ні в кого.
(Апостроф усередині текстового значення `'Від''ємний'` подвоюють, як
завжди в SQL: `$$` звільняє від подвоєння лише лапки навколо тіла.)

**Функцію не викликають через CALL:**

```text
CALL bad_func();

ERROR:  bad_func() is not a procedure
HINT:  To call a function, use SELECT.
```

Якщо потрібна логіка, що сама фіксує зміни частинами, для цього в
PostgreSQL є окремий вид об’єкта – **процедура** (`CREATE PROCEDURE`,
виклик `CALL`, практики 22–23). Але й процедура може виконати `COMMIT`
лише тоді, коли саму `CALL` викликано поза явною транзакцією.

## 6. Змінні, DECLARE і SELECT INTO

У PL/pgSQL можна оголошувати **змінні** – іменовані комірки для
проміжних значень, які існують лише під час виконання функції. Їх
описують у блоці `DECLARE` перед `BEGIN`, а значення з таблиці до змінної
читають командою `SELECT … INTO`. Функція, що формує короткий підсумок
про власника:

```sql
CREATE OR REPLACE FUNCTION owner_summary(p_owner_id INTEGER)
RETURNS TEXT AS $$
DECLARE
    v_name TEXT;
    v_cnt  INTEGER;
BEGIN
    SELECT last_name INTO v_name FROM owners WHERE id = p_owner_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Власника з id % не існує', p_owner_id;
    END IF;
    SELECT COUNT(*) INTO v_cnt FROM animals WHERE owner_id = p_owner_id;
    RETURN v_name || ': тварин ' || v_cnt;
END;
$$ LANGUAGE plpgsql;

SELECT owner_summary(1);
SELECT owner_summary(99);
```

```text
   owner_summary
--------------------
 Петренко: тварин 2

ERROR:  Власника з id 99 не існує
CONTEXT:  PL/pgSQL function owner_summary(integer) line 8 at RAISE
```

Номер рядка в `CONTEXT` PostgreSQL рахує від знака `$$`: рядок з `$$` – перший.

- Спеціальна змінна `FOUND` після `SELECT … INTO` дорівнює `true`, якщо
  запит знайшов рядок, і `false` в іншому разі.
- `RAISE EXCEPTION` зупиняє функцію з повідомленням про помилку; `%` у
  тексті підставляє значення наступного аргументу.
- Це кращий спосіб повідомити про неправильні вхідні дані, ніж повернути
  `NULL` чи `-1`: помилку неможливо не помітити, а спеціальне значення
  можна не перевірити й понести далі у звіт.

**Кілька колонок в INTO.** Одним `SELECT … INTO` можна прочитати кілька
колонок: змінні перелічують через кому в тому самому порядку, що й колонки.

```sql
CREATE FUNCTION owner_full(p_owner_id INTEGER)
RETURNS TEXT AS $$
DECLARE
    v_last  TEXT;
    v_first TEXT;
BEGIN
    SELECT last_name, first_name INTO v_last, v_first
    FROM owners WHERE id = p_owner_id;
    RETURN v_first || ' ' || v_last;
END;
$$ LANGUAGE plpgsql;

SELECT owner_full(1);    -- Ольга Петренко
```

Якщо потрібен увесь рядок, зручніше одна змінна типу «рядок таблиці»,
`%ROWTYPE`, а до колонок звертаються через крапку:

```sql
DECLARE
    v_owner owners%ROWTYPE;
BEGIN
    SELECT * INTO v_owner FROM owners WHERE id = p_owner_id;
    RETURN v_owner.first_name || ' ' || v_owner.last_name;
```

Дві пастки, на які PostgreSQL **не** відповідає помилкою:

- **кількість колонок і змінних не збігається:** зайві колонки
  відкидаються (`SELECT last_name, first_name INTO v_last` – у `v_last`
  буде прізвище, ім’я загубиться), а зайві змінні отримують `NULL`;
- **запит повертає кілька рядків:** у змінні потрапляє лише перший, решта
  мовчки відкидається. `SELECT name INTO v_name FROM animals WHERE
  owner_id = 1 ORDER BY name` дасть «Барсик», хоча котів у Петренко два.

Якщо рядок має бути рівно один, пишіть `INTO STRICT`: тоді PostgreSQL
перевірить це сам і зупинить функцію:

```text
ERROR:  query returned more than one row
HINT:  Make sure the query returns a single row, or use LIMIT 1.
```

а для нуля рядків – `ERROR:  query returned no rows`.

**Що буде без перевірки FOUND.** Якщо `SELECT … INTO` не знайшов рядка,
помилки немає: змінна просто отримує `NULL`. Без `IF NOT FOUND` виклик
`owner_summary(99)` тихо поверне `NULL`, бо склеювання з `NULL` дає
`NULL`, і ніхто не дізнається, що власника не існує.

**Чи можна замість `IF NOT FOUND` написати `IF NOT v_name`?** Ні.
`NOT` працює лише з логічними значеннями (`true`/`false`), а `v_name` –
текст. Функція створиться, але будь-який виклик, навіть для наявного
власника, дасть:

```text
ERROR:  argument of NOT must be type boolean, not type text
QUERY:  NOT v_name
```

Правильніше було б `IF v_name IS NULL THEN`: для власника 99 це спрацює.
Але така перевірка плутає «рядка немає» і «рядок є, а значення в колонці
– `NULL`». З `last_name` це не страшно, бо колонка `NOT NULL`. А от якщо
так перевіряти телефон, `SELECT phone INTO v_phone …` і
`IF v_phone IS NULL`, то для наявного власника без телефону функція
скаже «Власника з id 3 не існує». `FOUND` відповідає саме на питання «чи
знайдено рядок», тому для такої перевірки беріть його.

**FOUND після UPDATE, INSERT і DELETE.** `FOUND` встановлюють не лише
`SELECT … INTO`, а й команди, що змінюють дані: він дорівнює `true`, якщо
команда змінила хоча б один рядок. Так перевіряють, чи `UPDATE` взагалі
знайшов, що змінювати:

```sql
CREATE FUNCTION set_status(p_id INTEGER, p_status TEXT)
RETURNS VOID AS $$
BEGIN
    UPDATE animals SET status = p_status WHERE id = p_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Тварини з id % немає', p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT set_status(99, 'вибув');
```

```text
ERROR:  Тварини з id 99 немає
CONTEXT:  PL/pgSQL function set_status(integer,text) line 5 at RAISE
```

Без перевірки `UPDATE` для неіснуючого id мовчки змінив би 0 рядків.
Цей прийом знадобиться в процедурах на практичних 22–23.

**Префікси `p_` для параметрів і `v_` для змінних.** Це скорочення
англійських слів: `p_` – *parameter*, «параметр» (значення, яке функція
отримує під час виклику), `v_` – *variable*, «змінна» (проміжне значення
з блоку `DECLARE`). Для PostgreSQL це звичайна частина назви, а префікси
– домовленість для людей: у тілі функції одразу видно, що прийшло ззовні
(`p_`), що функція обчислила сама (`v_`), а що без префікса – колонка
таблиці. Вони не обов’язкові, але не дають назві збігтися з колонкою.
Якщо параметр назвати `owner_id`, як
колонку `animals.owner_id`, функція створиться, а виклик дасть:

```text
ERROR:  column reference "owner_id" is ambiguous
DETAIL:  It could refer to either a PL/pgSQL variable or a table column.
```

Перейменувати параметр через `CREATE OR REPLACE` не вийде
(`cannot change name of input parameter`): стару функцію спершу видаляють
(`DROP FUNCTION pets_count(INTEGER);`, розділ 10).

### Будова функції PL/pgSQL: шпаргалка

Усе, що досі траплялося окремо, в одній функції. Вона повертає картку
власника: прізвище і скільки в нього тварин словами.

```sql
CREATE OR REPLACE FUNCTION owner_card(p_owner_id INTEGER)  -- назва і параметри з типами
RETURNS TEXT AS $$                                         -- тип результату; тіло – між $$
DECLARE                                                    -- змінні: лише тут, до BEGIN
    v_name  owners.last_name%TYPE;                         -- тип – як у колонці owners.last_name
    v_cnt   INTEGER := 0;                                  -- з початковим значенням
    v_label TEXT;                                          -- без значення – спершу NULL
BEGIN                                                      -- початок команд (не транзакції!)
    SELECT last_name INTO v_name FROM owners WHERE id = p_owner_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Власника з id % не існує', p_owner_id;
    END IF;

    SELECT COUNT(*) INTO v_cnt FROM animals WHERE owner_id = p_owner_id;
    RAISE NOTICE 'Власник %, тварин: %', v_name, v_cnt;    -- повідомлення для налагодження

    v_label := CASE WHEN v_cnt = 0 THEN 'без тварин'       -- присвоєння :=
                    WHEN v_cnt = 1 THEN 'одна тварина'
                    ELSE 'кілька тварин'
               END;
    RETURN v_name || ': ' || v_label;                      -- результат і вихід з функції
END;
$$ LANGUAGE plpgsql;

SELECT owner_card(1);
SELECT owner_card(2);
```

```text
NOTICE:  Власник Петренко, тварин: 2
       owner_card
-------------------------
 Петренко: кілька тварин

NOTICE:  Власник Коваль, тварин: 1
      owner_card
----------------------
 Коваль: одна тварина
```

Будова: **заголовок** (`CREATE OR REPLACE FUNCTION`, параметри, `RETURNS`),
**тіло** між `$$`, у тілі – необов’язковий блок **`DECLARE`** і
обов’язковий блок **`BEGIN … END;`**, наприкінці – **`LANGUAGE plpgsql`**.
Кожна команда в тілі закінчується крапкою з комою, зокрема `END IF;` і
`END;`.

Що можна писати в тілі:

| Конструкція | Для чого | Приклад |
|---|---|---|
| `назва тип;` у `DECLARE` | оголосити змінну | `v_cnt INTEGER;` |
| `назва тип := значення;` | змінна з початковим значенням | `v_cnt INTEGER := 0;` |
| `назва таблиця.колонка%TYPE;` | тип «такий самий, як у колонці» | `v_name owners.last_name%TYPE;` |
| `назва таблиця%ROWTYPE;` | змінна для цілого рядка таблиці | `v_owner owners%ROWTYPE;` |
| `назва CONSTANT тип := значення;` | значення, яке не можна змінити | `k CONSTANT INTEGER := 12;` |
| `змінна := вираз;` | присвоєння | `v_label := 'без тварин';` |
| `SELECT … INTO змінна, … FROM …;` | записати результат запиту в змінні (кілька – через кому) | розділ 6 |
| `FOUND` | чи знайшов рядок останній `SELECT … INTO` | `IF NOT FOUND THEN …` |
| `IF … THEN … ELSIF … ELSE … END IF;` | вибрати, які команди виконати | розділ 3 |
| `CASE WHEN … THEN … ELSE … END` | вибрати значення (вираз) | розділ 3, приклад вище |
| `RAISE NOTICE 'текст %', значення;` | вивести повідомлення, функція працює далі | приклад вище |
| `RAISE EXCEPTION 'текст %', значення;` | зупинити функцію з помилкою, зміни запиту скасовуються | розділ 6 |
| `RETURN вираз;` | повернути значення і завершити функцію | розділ 1 |
| `RETURN QUERY SELECT …;` | повернути рядки (для `RETURNS TABLE`) | розділ 4 |
| `INSERT`, `UPDATE`, `DELETE` | змінити дані (у транзакції запиту) | розділ 5 |
| `FOR r IN SELECT … LOOP … END LOOP;` | перебрати рядки запиту по одному | нижче, «Цикли» |
| `FOR i IN 1..n LOOP … END LOOP;` | повторити дії для чисел від 1 до n | нижче, «Цикли» |

`%` у тексті `RAISE` замінюється значеннями після коми, по черзі.
`RAISE NOTICE` зручно ставити, щоб подивитися, що лежить у змінних: у psql
повідомлення видно над результатом, у pgAdmin – на вкладці *Messages*.

**Цикли.** Цикл повторює команди в тілі кілька разів. Головний цикл
PL/pgSQL – **перебір рядків запиту**: `FOR змінна IN SELECT … LOOP …
END LOOP;`. На кожному кроці в змінну потрапляє черговий рядок, і
команди між `LOOP` і `END LOOP` виконуються для нього. Функція, що
збирає тварин власника в один рядок тексту:

```sql
CREATE FUNCTION owner_pets(p_owner_id INTEGER)
RETURNS TEXT AS $$
DECLARE
    r      RECORD;            -- «поточний рядок» циклу
    v_list TEXT := '';
BEGIN
    FOR r IN SELECT name, species FROM animals
             WHERE owner_id = p_owner_id ORDER BY name LOOP
        IF v_list <> '' THEN
            v_list := v_list || ', ';
        END IF;
        v_list := v_list || r.name || ' (' || r.species || ')';
    END LOOP;
    RETURN v_list;
END;
$$ LANGUAGE plpgsql;

SELECT owner_pets(1);
```

```text
        owner_pets
---------------------------
 Барсик (кіт), Мурка (кіт)
```

- `RECORD` – тип змінної «рядок будь-якої будови»: її колонки беруть з
  того запиту, який зараз перебирає цикл. До колонок звертаються через
  крапку: `r.name`, `r.species`.
- Змінну циклу по рядках треба оголосити в `DECLARE`. Без цього функція
  не створиться: `ERROR:  loop variable of loop over rows must be a
  record variable or list of scalar variables`.
- Порядок перебору задає `ORDER BY` у запиті циклу; без нього порядок не
  гарантовано.
- Якщо запит не повернув жодного рядка, тіло циклу не виконується ні разу
  (для власника 99 функція поверне порожній рядок).
- Забули `END LOOP;` – функція не створиться: `syntax error`.

Другий вид – **цикл за числами**, `FOR i IN 1..n LOOP`. Змінну `i`
оголошувати не треба, PostgreSQL створює її сам:

```sql
FOR i IN 1..p_years LOOP
    v := v || i || ' р. = ' || i * 12 || ' міс.; ';
END LOOP;
```

Для `p_years = 3` вийде `1 р. = 12 міс.; 2 р. = 24 міс.; 3 р. = 36 міс.;`.
Є ще `WHILE умова LOOP … END LOOP;` (повторювати, поки умова істинна) і
`EXIT;` (вийти з циклу достроково), але в курсі вони не знадобляться.

**Коли цикл не потрібен.** Усе, що можна зробити одним запитом, робіть
одним запитом: так коротше й значно швидше, ніж обробляти рядки по одному.
Список тварин вище дає й звичайний `SELECT` з агрегатною функцією
`string_agg`, що склеює значення групи через роздільник:

```sql
SELECT string_agg(name || ' (' || species || ')', ', ' ORDER BY name)
FROM animals WHERE owner_id = 1;     -- Барсик (кіт), Мурка (кіт)
```

Так само «змінити ціну всім» – це один `UPDATE`, а не цикл з `UPDATE` для
кожного рядка. Цикл потрібен, коли з кожним рядком треба зробити кілька
кроків з перевірками або фіксувати роботу частинами, як у процедурі з
`COMMIT` на практиці 23.

**Типові помилки з типами.** Тип потрібен кожному параметру й кожній
змінній. Без нього функція не створиться:

| Що написали | Що відповість PostgreSQL |
|---|---|
| `DECLARE v_name;` | `ERROR:  missing data type declaration at or near ";"` |
| `owner_summary(p_owner_id)` – параметр без типу | `ERROR:  type p_owner_id does not exist` |
| `k CONSTANT INTEGER := 12;`, а далі `k := 5;` | `ERROR:  variable "k" is declared CONSTANT` |

А якщо тип вказано, але не той, функція створюється, і помилка
з’являється лише під час виклику:

| Що сталося | Що відповість PostgreSQL |
|---|---|
| `v_cnt INTEGER`, а в нього записали прізвище: `SELECT last_name INTO v_cnt …` | `ERROR:  invalid input syntax for type integer: "Петренко"` |
| `RETURNS INTEGER`, а повертають текст: `RETURN 'abc';` | `ERROR:  invalid input syntax for type integer: "abc"` (`… while casting return value to function's return type`) |

Тип `%TYPE` якраз захищає від першого випадку: змінна отримує тип колонки,
і якщо колонку колись змінять, змінна зміниться разом із нею.

**Аргумент не того типу.** Функцію PostgreSQL шукає за назвою **і** типами
аргументів (сигнатура, розділ 10). Для `owner_summary(p_owner_id INTEGER)`:

| Виклик | Результат |
|---|---|
| `owner_summary(1)` | працює |
| `owner_summary('1')` | працює: текст у лапках без типу PostgreSQL сам перетворює на `INTEGER` |
| `owner_summary('abc')` | `ERROR:  invalid input syntax for type integer: "abc"` |
| `owner_summary(1.5)` | `ERROR:  function owner_summary(numeric) does not exist` і `HINT:  … You might need to add explicit type casts.` |
| `owner_summary(1::BIGINT)` | `ERROR:  function owner_summary(bigint) does not exist` – навіть ціле, але іншого типу |
| `owner_summary(1, 2)`, `owner_summary()` | `ERROR:  function … does not exist`: інша кількість аргументів |
| `owner_summary(NULL)` | виконується: власника не знайдено – `Власника з id <NULL> не існує` |

Дробове число чи `BIGINT` PostgreSQL сам у `INTEGER` не перетворює: для
нього це виклик іншої функції, якої немає. Допомагає явне приведення,
але з обережністю: `owner_summary(1.5::INTEGER)` округлить 1.5 до 2 і
покаже власника з id 2.

## 7. NULL у функції: пастка з IF

Що поверне `age_category` з розділу 3 для тварини, вік якої невідомий?
Порівняння `NULL < 1` не дає ні `true`, ні `false`, а дає невизначений
результат, і `IF` трактує його як хибний. Те саме з `ELSIF`, тож
виконання доходить до гілки `ELSE`:

```sql
SELECT age_category(NULL);
```

```text
 age_category
--------------
 старший
```

Тварина з невідомим віком стала «старшою»: помилки немає, але результат
хибний. Виправлення – обробити `NULL` першою гілкою:

```sql
CREATE OR REPLACE FUNCTION age_category(age_years INTEGER)
RETURNS TEXT AS $$
BEGIN
    IF age_years IS NULL THEN
        RETURN 'вік невідомий';
    ELSIF age_years < 1 THEN
        RETURN 'малюк';
    ELSIF age_years < 7 THEN
        RETURN 'дорослий';
    ELSE
        RETURN 'старший';
    END IF;
END;
$$ LANGUAGE plpgsql;
```

Сигнатура та сама, тому `CREATE OR REPLACE` замінив функцію, і тепер
`age_category(NULL)` повертає `вік невідомий`. Загальне правило: після
кожного порівняння питайте себе, що станеться, якщо значення відсутнє.

## 8. Функція в WHERE та інших частинах запиту

Результат функції можна використовувати всюди, де потрібне значення: у
`WHERE`, `ORDER BY`, `GROUP BY`. Знайдемо всіх дорослих тварин:

```sql
SELECT name FROM animals WHERE age_category(age) = 'дорослий' ORDER BY id;
```

```text
  name
--------
 Мурка
 Барсик
 Пушок
```

Такий запит читається майже як речення, але має ціну:

```sql
EXPLAIN SELECT name FROM animals WHERE age_category(age) = 'дорослий';
```

```text
                        QUERY PLAN
----------------------------------------------------------
 Seq Scan on animals  (cost=0.00..167.50 rows=3 width=32)
   Filter: (age_category(age) = 'дорослий'::text)
```

`Seq Scan` – повний перебір таблиці: функція викликається для кожного
рядка. Індекс на колонці `age` (лекція 13) такій умові не допоможе: умова
стоїть не над колонкою, а над виразом з колонкою, і PostgreSQL не знає,
які значення `age` дають «дорослий», не викликавши функцію. Якщо
швидкість важлива, умову пишуть прямо над колонкою:
`WHERE age >= 1 AND age < 7` – тоді PostgreSQL може використати індекс,
якщо умова відбирає невелику частину рядків.

Індекс за виразом `age_category(age)` теж не створити:
`ERROR:  functions in index expression must be marked IMMUTABLE`. Нова
функція за замовчуванням позначена як `VOLATILE` («мінлива»): PostgreSQL
не вважає, що для тих самих аргументів вона завжди повертає той самий
результат. Протилежна позначка, `IMMUTABLE`, означає саме таку обіцянку;
функцію можна так позначити, але за правдивість обіцянки тоді відповідає
автор функції. У курсі цього не робимо.

## 9. Проста функція мовою SQL

Якщо в тілі функції лише один запит, не потрібні ні `BEGIN`, ні змінні,
ні `IF`: досить мови `sql`, у якій тіло – просто `SELECT`:

```sql
CREATE FUNCTION count_by_species(p_species TEXT)
RETURNS INTEGER AS $$
    SELECT COUNT(*)::INTEGER FROM animals WHERE species = p_species;
$$ LANGUAGE sql;

SELECT count_by_species('кіт'), count_by_species('птах');
```

```text
 count_by_species | count_by_species
------------------+------------------
                2 |                0
```

`::INTEGER` явно приводить результат `COUNT` (тип `BIGINT`) до
оголошеного типу `INTEGER`. У PostgreSQL 18 sql-функція приведе тип і
без нього, але `RETURN QUERY` у plpgsql такої поблажки не робить
(розділ 4), тому приведення краще писати завжди: одразу видно, що тип
змінюється навмисно. Для одного запиту обирайте `sql`, бо код коротший.
Якщо потрібні змінні, умови, цикли чи обробка помилок, обирайте `plpgsql`.

## 10. Перегляд, перевантаження і видалення функцій

У PostgreSQL можуть існувати кілька функцій з однаковою назвою, якщо в
них різні типи параметрів.

> **Сигнатура функції** – її назва разом зі списком типів параметрів.
> **Перевантаження** (overloading) – існування кількох функцій з
> однаковою назвою, але різними сигнатурами; PostgreSQL обирає потрібну
> за типами аргументів.

Наприклад, щоб передавати вік дробом (0.5 року для цуценяти), поруч із
`age_category(INTEGER)` створимо `age_category(NUMERIC)` з тим самим
тілом. Тоді `age_category(0.5)` поверне `малюк` (версія з `NUMERIC`), а
`age_category(3)` – `дорослий` (версія з `INTEGER`). Виклик із голим
`NULL` стає неоднозначним:

```text
ERROR:  function age_category(unknown) is not unique
HINT:  Could not choose a best candidate function. You might need to add explicit type casts.
```

Допомагає явне приведення: `age_category(NULL::INTEGER)`. Перелік
функцій з їхніми параметрами в `psql` показує команда `\df`:

```text
\df age_category

 Schema |     Name     | Result data type | Argument data types | Type
--------+--------------+------------------+---------------------+------
 public | age_category | text             | age_years integer   | func
 public | age_category | text             | age_years numeric   | func
```

У pgAdmin функції видно у вітці **Functions** вашої бази (Schemas, public,
Functions). Видалення за самою назвою завершується помилкою:

```sql
DROP FUNCTION age_category;
```

```text
ERROR:  function name "age_category" is not unique
HINT:  Specify the argument list to select the function unambiguously.
```

Потрібно вказати типи: `DROP FUNCTION age_category(NUMERIC);`.

Звідси правило: `CREATE OR REPLACE FUNCTION` замінює функцію лише з
**тією самою** сигнатурою. Якщо змінити тип параметра, PostgreSQL
створить нову, перевантажену функцію, а стара залишиться.

## 11. Запитання для самоперевірки

**Чому функція з `COMMIT` створюється без помилки, а падає лише під час виклику?**

Під час `CREATE FUNCTION` перевіряється лише синтаксис тіла, а `COMMIT`
синтаксично допустимий (його використовують процедури). Заборона
залежить від контексту виконання: функцію викликають із запиту, і вона
працює всередині транзакції цього запиту, яку не може завершити.

**Для чого потрібен блок `DECLARE` у функції?**

Він оголошує локальні змінні для проміжних значень. Блок пишуть перед
`BEGIN`, кожну змінну з типом.

**Що робить `RAISE EXCEPTION` і чим це краще за повернення спеціального значення на кшталт `-1`?**

Перериває виконання функції з повідомленням про помилку. Помилку
неможливо проігнорувати, а спеціальне значення викликач може не
перевірити й продовжити роботу з хибними даними.

**Яким буде результат `age_category(NULL)` у функції з розділу 3 і чому?**

`старший`. Порівняння з `NULL` дає невизначений результат, що в `IF`
вважається хибним, тож виконується гілка `ELSE`. Потрібна окрема
перевірка `IF age_years IS NULL`.

**Навіщо в `RETURN QUERY` писати `a.id`, а не `id`?**

Колонки з `RETURNS TABLE` усередині функції теж є змінними, і без
псевдоніма PostgreSQL не знає, що означає `id`: змінну чи колонку
таблиці (`column reference "id" is ambiguous`).

**Коли замість `plpgsql` досить `LANGUAGE sql`?**

Коли тіло функції складається з одного запиту: змінні, умови й цикли не
потрібні.

**Чому `DROP FUNCTION age_category` може завершитися помилкою, хоча функція існує?**

Існує кілька перевантажених функцій з цією назвою, і PostgreSQL не знає,
яку видалити. Потрібно вказати типи параметрів:
`DROP FUNCTION age_category(NUMERIC)`.

## Підсумок

- `CREATE FUNCTION назва(параметр тип) RETURNS тип AS $$ … $$ LANGUAGE
  plpgsql;` – збережена функція, яку викликають у будь-якому запиті, як
  вбудовану.
- `IF`/`ELSIF`/`ELSE` виконують першу істинну гілку; `NULL` обробляють
  першою гілкою `IS NULL`, а кожен шлях має дійти до `RETURN`.
- Функція у `WHERE` викликається для кожного рядка, індекс на колонці не
  допоможе.
- `DECLARE`, `SELECT … INTO`, `FOUND` і `RAISE EXCEPTION`; параметрам –
  префікс `p_`, змінним – `v_`.
- `RETURNS TABLE(...)` + `RETURN QUERY` повертають набір рядків; у запиті
  – псевдоніми таблиць, типи – точно як у `RETURNS TABLE`.
- Функція працює в транзакції запиту: `COMMIT` у ній дає помилку
  `invalid transaction termination` під час виклику, помилка скасовує всі
  зміни запиту, а `CALL` – лише для процедур.
- Для одного запиту досить `LANGUAGE sql`; функцію визначають назва і
  типи параметрів: `DROP FUNCTION назва(типи)`.

**Практика до цієї лекції:** [Практика 21. Написання функцій у PostgreSQL](../practice/21-functions.md)

## Рекомендована література

Павловський В. І., Петрашенко А. В. *Бази даних та засоби управління.* – Київ: КПІ ім. Ігоря Сікорського, 2024 ([відкритий доступ](https://ela.kpi.ua/bitstreams/9f26675d-c42f-485e-aab5-13e6e014b560/download)). Розділ «PostgreSQL і PL/pgSQL» – створення функцій мовою PL/pgSQL.

Павловський В. І., Петрашенко А. В., Победа Д. В. *Бази даних та засоби управління. Практикум.* – Київ: КПІ ім. Ігоря Сікорського, 2021 ([відкритий доступ](https://ela.kpi.ua/server/api/core/bitstreams/1b620029-0db7-4e2e-83e7-32f7722a69be/content)). Розділ про збережені процедури та тригери – створення серверних функцій (server-side function creation).
