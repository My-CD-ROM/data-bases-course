# Лекція 18. Тригери (Triggers) у PostgreSQL

*Функції (лекція 17) і процедури (практики 22–23) виконуються лише тоді,
коли їх явно викликають: `SELECT` чи `CALL`. Але деякі дії мають
відбуватися завжди, щойно змінюються дані: записати зміну в журнал, не
пустити в таблицю від’ємний вік, зберегти копію видаленого рядка. І
байдуже, хто змінює дані – адміністратор у pgAdmin, програма сайту чи
процедура. Для цього в PostgreSQL є **тригер**.*

> **Тригер (trigger)** – об’єкт бази даних, який автоматично виконує
> задану функцію, коли в певній таблиці відбувається `INSERT`, `UPDATE`
> або `DELETE`.

**База для прикладів.** Як і в попередніх лекціях модуля, працюємо з
демобазою ветклініки: базою, щойно завантаженою з файлу
[`vet_clinic_demo.sql`](../practice/sql/22-procedures/vet_clinic_demo.sql)
(практика 22). Таблиці: `owners`, `animals` (колонка `status` –
`NOT NULL DEFAULT 'на обліку'`), `vets`, `visits`. У `animals` чотири
тварини: Мурка, Барсик, Рекс і Пушок, усі «на обліку». Приклади нижче
виконуються один за одним у тому порядку, як ідуть на сторінці, тож
номери `id` і вміст журналу залежать від попередніх кроків.

## 1. Функція-тригер: RETURNS TRIGGER, NEW і OLD

Тригери в прикладах пишуть журнал змін у таблицю `animal_log` (таку саму
створюють на практиці 24):

```sql
CREATE TABLE animal_log (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    animal_id INTEGER,
    action TEXT,
    old_status TEXT,
    new_status TEXT,
    logged_at TIMESTAMP DEFAULT now()
);
```

Тригер завжди складається з двох частин: функції, яка виконує роботу, і
команди `CREATE TRIGGER` (розділ 2), яка прив’язує цю функцію до таблиці.
Спершу функція:

```sql
CREATE FUNCTION log_status_change() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO animal_log (animal_id, action, old_status, new_status)
        VALUES (NEW.id, 'INSERT', NULL, NEW.status);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO animal_log (animal_id, action, old_status, new_status)
        VALUES (NEW.id, 'UPDATE', OLD.status, NEW.status);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

> **Функція-тригер** – функція без параметрів, яка повертає тип
> `TRIGGER` і виконується лише тригером, а не прямим викликом.

Усередині функції-тригера PostgreSQL сам заповнює спеціальні змінні:

- `NEW` – рядок після зміни (для `INSERT` і `UPDATE`; для `DELETE` він
  дорівнює `NULL`);
- `OLD` – рядок до зміни (для `UPDATE` і `DELETE`; для `INSERT` він
  дорівнює `NULL`);
- `TG_OP` – назва операції: `'INSERT'`, `'UPDATE'` або `'DELETE'`. Завдяки
  їй одна функція обробляє різні події по-різному.

Функцію-тригер не можна викликати як звичайну, бо лише тригер заповнює
`NEW`, `OLD` і `TG_OP`:

```sql
SELECT log_status_change();
```

```text
ERROR:  trigger functions can only be called as triggers
CONTEXT:  compilation of PL/pgSQL function "log_status_change" near line 1
```

Перевіряють функцію-тригер командами `INSERT`, `UPDATE` чи `DELETE` у
таблиці, до якої прив’язано тригер.

## 2. CREATE TRIGGER – прив’язка функції до таблиці

```sql
CREATE TRIGGER trg_log_status
AFTER INSERT OR UPDATE ON animals
FOR EACH ROW
EXECUTE FUNCTION log_status_change();
```

Тригер `trg_log_status` спрацьовує після (`AFTER`) кожного `INSERT` чи
`UPDATE` у таблиці `animals`, окремо для кожного зміненого рядка
(`FOR EACH ROW`). Якщо команда змінить три рядки, функція виконається
тричі; якщо `WHERE` не знайде жодного рядка (`UPDATE 0`), тригер не
спрацює зовсім.

Порядок команд важливий: тригер посилається на функцію за назвою, тож
спершу `CREATE FUNCTION`, потім `CREATE TRIGGER`. Якщо виконати
`CREATE TRIGGER` першим:

```text
ERROR:  function log_status_change() does not exist
```

У старих підручниках трапляється запис `EXECUTE PROCEDURE` замість
`EXECUTE FUNCTION`. Це той самий тригер: PostgreSQL 18 старий запис ще
приймає, але зберігає тригер уже як `EXECUTE FUNCTION`.

Перевіримо: додамо пса Біма і знімемо його з обліку.

```sql
INSERT INTO animals (name, species, age) VALUES ('Бім', 'собака', 2);
UPDATE animals SET status = 'вибув' WHERE id = 5;

SELECT animal_id, action, old_status, new_status FROM animal_log ORDER BY id;
```

```text
 animal_id | action | old_status | new_status
-----------+--------+------------+------------
         5 | INSERT |            | на обліку
         5 | UPDATE | на обліку  | вибув
```

Жодного `INSERT` в `animal_log` ми не писали: обидва записи зробив
тригер. Статус «на обліку» Бім отримав від `DEFAULT`.

Чому журнал ведуть тригером, а не окремим `INSERT` у програмі? Такий
`INSERT` довелося б писати в кожному місці програми, де змінюють тварин,
і досить забути одне, щоб журнал став неповним, причому ніхто цього не
помітить. До того ж зміни, зроблені просто в pgAdmin, програму обходять.
Тригер прив’язаний до таблиці, тому спрацьовує при будь-якій зміні.

## 3. BEFORE-тригер: перевірка й блокування операції

```sql
CREATE FUNCTION prevent_negative_age() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.age < 0 THEN
        RAISE EXCEPTION 'Вік не може бути від''ємним: %', NEW.age;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_age
BEFORE INSERT OR UPDATE ON animals
FOR EACH ROW
EXECUTE FUNCTION prevent_negative_age();
```

`BEFORE` означає, що тригер спрацьовує до запису рядка в таблицю.
`RAISE EXCEPTION` зупиняє виконання з помилкою; `%` у тексті заміняється
значенням після коми.

Апостроф усередині рядка SQL треба подвоїти: `від''ємним`. Якщо написати
один, PostgreSQL вирішить, що рядок закінчився на «від», і функція не
створиться:

```text
ERROR:  syntax error at or near "ємним"
```

Спробуємо додати тварину з від’ємним віком:

```sql
INSERT INTO animals (name, species, age) VALUES ('Тайсон', 'собака', -3);
```

```text
ERROR:  Вік не може бути від'ємним: -3
CONTEXT:  PL/pgSQL function prevent_negative_age() line 4 at RAISE
```

`CONTEXT` показує, де виникла помилка: функція, номер рядка, команда
`RAISE`. `SELECT COUNT(*) FROM animals` і далі повертає 5: Тайсона в
таблиці немає.

Якщо вік не вказати (`age` дорівнює `NULL`), тригер рядок пропустить:
`NULL < 0` дає не істину, а невизначений результат. Так само поводиться й
`CHECK (age >= 0)`. Обов’язковість значення задають через `NOT NULL`.

**Скасовується вся команда.** Якщо команда вставляє кілька рядків, а
поганий лише один, не вставиться жоден:

```sql
INSERT INTO animals (name, species, age)
VALUES ('Луна', 'кіт', 2), ('Тайсон', 'собака', -3), ('Боня', 'собака', 4);
SELECT COUNT(*) FROM animals;          -- 5, як і було

INSERT INTO animals (name, species, age) VALUES ('Ласка', 'кіт', 2);
SELECT id, name FROM animals WHERE name = 'Ласка';
```

```text
 id | name
----+-------
  9 | Ласка
```

Тригер пропустив Луну, спіткнувся на Тайсоні, і скасовано всю команду,
разом з уже обробленою Луною. Але номери, видані лічильником `IDENTITY`,
не повертаються: лічильник видає номер ще до `BEFORE`-тригера (тригер
уже бачить `NEW.id`). Номер 6 забрала перша спроба з Тайсоном, номери 7 і
8 – Луна й Тайсон з команди на три рядки. Тому Ласка отримала 9, а не 6
(про лічильник як окремий об’єкт – лекція 15, розділ 3).

Якщо таку команду виконати всередині відкритої транзакції (після
`BEGIN`), зламається вся транзакція: кожна наступна команда до `ROLLBACK`
отримає відповідь

```text
ERROR:  current transaction is aborted, commands ignored until end of transaction block
```

## 4. AFTER проти BEFORE, тригер проти CHECK

`BEFORE` використовують для перевірок і для зміни самого рядка перед
записом (розділ 7). `AFTER` – коли зміна вже відбулася і потрібна дія з
іншими таблицями: журнал (розділ 2), архів (розділ 6).

**`RAISE EXCEPTION` в `AFTER`-тригері теж скасовує зміну.** Рядок на той
момент уже записано, але помилка скасовує всю команду, а з нею й рядок:

```sql
CREATE FUNCTION check_age_limit() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.age > 30 THEN
        RAISE EXCEPTION 'Завеликий вік: %', NEW.age;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_age_limit AFTER INSERT OR UPDATE ON animals
FOR EACH ROW EXECUTE FUNCTION check_age_limit();

INSERT INTO animals (name, species, age) VALUES ('Тортила', 'черепаха', 200);
```

```text
ERROR:  Завеликий вік: 200
CONTEXT:  PL/pgSQL function check_age_limit() line 4 at RAISE
```

`SELECT COUNT(*) FROM animals WHERE name = 'Тортила'` повертає 0. Скасовано
навіть запис, який устиг зробити журнальний тригер: у `animal_log` як було
три записи, так і лишилося. Для перевірок однаково обирають `BEFORE`: він
зупиняє операцію раніше, без зайвого запису, і лише в ньому можна змінити
`NEW`. Після експерименту тригер видаляємо:
`DROP TRIGGER trg_age_limit ON animals;`.

**Обидва тригери разом.** На `animals` тепер діють `AFTER`-тригер журналу
і `BEFORE`-тригер віку. Знімемо з обліку Барсика, а потім спробуємо зняти
Пушка з помилковим віком:

```sql
UPDATE animals SET status = 'вибув' WHERE id = 2;
UPDATE animals SET status = 'вибув', age = -1 WHERE id = 4;

SELECT animal_id, action, old_status, new_status FROM animal_log ORDER BY id;
```

```text
UPDATE 1
ERROR:  Вік не може бути від'ємним: -1
CONTEXT:  PL/pgSQL function prevent_negative_age() line 4 at RAISE
 animal_id | action | old_status | new_status
-----------+--------+------------+------------
         5 | INSERT |            | на обліку
         5 | UPDATE | на обліку  | вибув
         9 | INSERT |            | на обліку
         2 | UPDATE | на обліку  | вибув
```

Успішна зміна Барсика є в журналі, заблокованої зміни Пушка – немає:
`BEFORE`-тригер скасував команду ще до `AFTER`-тригера, а навіть якби той
устиг спрацювати, його запис скасувався б разом з командою. Пушок
лишився «на обліку» з віком 1. Саме це перевіряють у завданні 5
практики 24.

**Тригер чи `CHECK`.** Умову одного рядка, як `age >= 0`, простіше
записати обмеженням `CHECK` (лекція 6): його видно в структурі таблиці, і
воно нічого не робить приховано. Якби тригера на вік не було, на порушення
PostgreSQL відповів би
`ERROR:  new row for relation "animals" violates check constraint "chk_age"`.
Але `CHECK` бачить лише рядок, який записують. Правило «візит можна
записати лише для тварини на обліку» зачіпає іншу таблицю, і `CHECK` з
підзапитом PostgreSQL не приймає:

```sql
ALTER TABLE visits ADD CONSTRAINT chk_active
    CHECK ((SELECT status FROM animals WHERE id = animal_id) = 'на обліку');
```

```text
ERROR:  cannot use subquery in check constraint
```

Тригер може виконати будь-який `SELECT`:

```sql
CREATE FUNCTION check_visit() RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT status FROM animals WHERE id = NEW.animal_id) <> 'на обліку' THEN
        RAISE EXCEPTION 'Тварина % не на обліку, візит не записано', NEW.animal_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_visit BEFORE INSERT ON visits
FOR EACH ROW EXECUTE FUNCTION check_visit();

INSERT INTO visits (animal_id, vet_id, visit_date) VALUES (5, 1, '2026-10-20');
INSERT INTO visits (animal_id, vet_id, visit_date) VALUES (1, 1, '2026-10-20');
```

```text
ERROR:  Тварина 5 не на обліку, візит не записано
CONTEXT:  PL/pgSQL function check_visit() line 4 at RAISE
INSERT 0 1
```

Отже, `CHECK` – для умов одного рядка; тригер – коли умова зачіпає інші
таблиці або інші рядки тієї самої таблиці (наприклад, «не більше трьох
візитів на день»). Тригер `FOR EACH ROW`, що рахує рядки через
`SELECT COUNT(*)`, бачить навіть рядки, щойно вставлені тією самою
командою.

Тригер може й змінювати інші таблиці: наприклад, `AFTER`-тригер на `visits`
міг би ставити тварині статус «на лікуванні», а цей `UPDATE animals`
запустив би тригер журналу на `animals`. Такий ланцюжок тригерів – частина
однієї команди: помилка в будь-якій ланці скасовує все.

## 5. Журнал, що пише зайве: умови спрацювання

Тригер `trg_log_status` із розділу 2 спрацьовує після **кожного** `UPDATE`
таблиці `animals`, навіть якщо статус не змінився. Збільшимо на рік вік
обох котів Ольги Петренко (`owner_id = 1`):

```sql
UPDATE animals SET age = age + 1 WHERE owner_id = 1;

SELECT animal_id, action, old_status, new_status FROM animal_log ORDER BY id;
```

```text
 animal_id | action | old_status | new_status
-----------+--------+------------+------------
         5 | INSERT |            | на обліку
         5 | UPDATE | на обліку  | вибув
         9 | INSERT |            | на обліку
         2 | UPDATE | на обліку  | вибув
         1 | UPDATE | на обліку  | на обліку
         2 | UPDATE | вибув      | вибув
```

Два останні записи зайві: змінився вік, а не статус. З часом такий журнал
складається здебільшого із записів, де нічого не змінилося. Тригеру можна
вказати два уточнення прямо в `CREATE TRIGGER`. Старий тригер видаляємо:
без цього новий `trg_log_status` з тією самою назвою не створиться
(`ERROR:  trigger "trg_log_status" for relation "animals" already exists`):

```sql
DROP TRIGGER trg_log_status ON animals;

CREATE TRIGGER trg_log_insert
AFTER INSERT ON animals
FOR EACH ROW
EXECUTE FUNCTION log_status_change();

CREATE TRIGGER trg_log_status
AFTER UPDATE OF status ON animals
FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status)
EXECUTE FUNCTION log_status_change();
```

- `UPDATE OF status` – тригер реагує лише на команди, які **згадують**
  колонку `status` у `SET`.
- `WHEN (...)` – умова, яку перевіряють перед запуском функції: якщо вона
  не істинна, функція не виконується. Так відсікаються випадки, коли
  значення записали, але воно не змінилося.
- `IS DISTINCT FROM` – «не дорівнює» з правильною обробкою `NULL`:
  звичайне `<>` із `NULL` дає невизначений результат, і зміну з `NULL` на
  значення тригер пропустив би.

Тригерів два, бо в тригері на `INSERT` старого рядка немає, і умову з
`OLD` PostgreSQL не дозволяє:

```text
ERROR:  INSERT trigger's WHEN condition cannot reference OLD values
```

Перевіримо. `TRUNCATE` видаляє з таблиці всі рядки одразу; очистимо так
журнал, знову змінимо вік котам і двічі повернемо Барсика на облік:

```sql
TRUNCATE animal_log;
UPDATE animals SET age = age + 1 WHERE owner_id = 1;
UPDATE animals SET status = 'на обліку' WHERE id = 2;
UPDATE animals SET status = 'на обліку' WHERE id = 2;

SELECT animal_id, action, old_status, new_status FROM animal_log ORDER BY id;
```

```text
 animal_id | action | old_status | new_status
-----------+--------+------------+------------
         2 | UPDATE | вибув      | на обліку
```

Зміна віку запису не дала, перше повернення Барсика – один запис, повтор –
жодного.

З PostgreSQL 14 тригер можна замінити без `DROP`: `CREATE OR REPLACE
TRIGGER` з тією самою назвою замінює старе визначення новим.

## 6. Тригер на видалення і змінна OLD

Для `INSERT` у функції-тригері має зміст лише `NEW`, а для `DELETE` лише
`OLD`: нового рядка під час видалення немає. Це дає змогу зберегти копію
видаленого запису в архіві:

```sql
CREATE TABLE animals_archive (id INTEGER, name TEXT, species TEXT,
                              deleted_at TIMESTAMP);

CREATE FUNCTION archive_animal() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO animals_archive (id, name, species, deleted_at)
    VALUES (OLD.id, OLD.name, OLD.species, now());
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_archive AFTER DELETE ON animals
FOR EACH ROW EXECUTE FUNCTION archive_animal();

DELETE FROM animals WHERE id = 5;

SELECT id, name, species FROM animals_archive;
```

```text
 id | name | species
----+------+---------
  5 | Бім  | собака
```

Біма видаляємо, бо в нього немає візитів. Рекса видалити не вдасться: на
нього посилається рядок `visits`, і зовнішній ключ заборонить видалення
(`Key (id)=(3) is still referenced from table "visits"`).

У тригері на `DELETE` повертають `OLD`, а не `NEW`: `NEW` тут дорівнює
`NULL`. Наш тригер має тип `AFTER`, тож результат функції ігнорується. Але
в `BEFORE DELETE`-тригері результат вирішує долю операції: `BEFORE
DELETE`-тригер з `RETURN NEW` мовчки скасовує видалення, і команда
відповідає `DELETE 0`.

## 7. BEFORE-тригер: змінити рядок або тихо його скасувати

У `BEFORE`-тригері можна не лише відхилити операцію через `RAISE
EXCEPTION` (розділ 3), а й **змінити** рядок, перш ніж він потрапить у
таблицю. Присвоєння `NEW.колонка := значення` (знак `:=` – присвоєння в
PL/pgSQL) підмінює значення, яке буде записано:

```sql
CREATE FUNCTION normalize_name() RETURNS TRIGGER AS $$
BEGIN
    NEW.name := initcap(trim(NEW.name));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_normalize BEFORE INSERT OR UPDATE ON animals
FOR EACH ROW EXECUTE FUNCTION normalize_name();

INSERT INTO animals (name, species, age) VALUES ('   ДЖЕК  ', 'собака', 1);

SELECT id, name FROM animals WHERE species = 'собака' ORDER BY id;
```

```text
 id | name
----+------
  3 | Рекс
 11 | Джек
```

`trim` прибрав пробіли на краях, `initcap` зробив першу літеру слова
великою, решту – малими. Зверніть увагу:

- таке виправлення працює лише в `BEFORE`; в `AFTER`-тригері рядок уже
  записано, присвоєння `NEW` нічого не змінить, і помилки теж не буде;
- в `UPDATE` рядок `NEW` – це старий рядок разом зі змінами з `SET`: навіть
  якщо змінили лише вік, `NEW.name` містить кличку, і тригер її знову
  обробить;
- `initcap` вважає апостроф межею слова: `initcap('мар''яна')` дає
  `Мар'Яна`. Користувач, що вводив дані, про таку обробку не знає, у цьому
  і користь, і небезпека тригерів.

**`RETURN NULL` – тихе скасування.** `RETURN NEW` у `BEFORE`-тригері
означає «записуй», а `RETURN NULL` – «пропусти цей рядок» без жодної
помилки. Замінимо в перевірці віку `RAISE EXCEPTION` на `RETURN NULL`
(тригер `trg_check_age` лишається той самий) і повторимо команду з
розділу 3:

```sql
CREATE OR REPLACE FUNCTION prevent_negative_age() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.age < 0 THEN
        RETURN NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

INSERT INTO animals (name, species, age)
VALUES ('Луна', 'кіт', 2), ('Тайсон', 'собака', -3), ('Боня', 'собака', 4);

SELECT id, name, age FROM animals WHERE name IN ('Луна', 'Тайсон', 'Боня');
```

```text
INSERT 0 2
 id | name | age
----+------+-----
 12 | Луна |   2
 14 | Боня |   4
```

`RAISE EXCEPTION` скасовує всю команду і повідомляє про помилку. `RETURN
NULL` пропускає лише поганий рядок, решта записується, і команда
завершується успішно: користувач вважає, що зберіг трьох тварин, а в
таблиці дві. Тому `RETURN NULL` у перевірках небезпечний. Після
експерименту повертаємо функцію з `RAISE EXCEPTION` (той самий
`CREATE OR REPLACE FUNCTION`, що в розділі 3).

**Помилки функції-тригера.** Функція, оголошена як `RETURNS VOID`,
створюється, але тригер для неї – ні:

```text
ERROR:  function check_name must return type trigger
```

А якщо функція `RETURNS TRIGGER` не має `RETURN` (наприклад, після `END
IF` забули `RETURN NEW`), кожна вставка завершується помилкою, і рядок не
потрапляє в таблицю:

```text
ERROR:  control reached end of trigger procedure without RETURN
CONTEXT:  PL/pgSQL function check_name()
```

## 8. Керування тригерами

Список тригерів таблиці зберігає системний каталог `pg_trigger`:

```sql
SELECT tgname, tgenabled
FROM pg_trigger
WHERE tgrelid = 'animals'::regclass AND NOT tgisinternal
ORDER BY tgname;
```

```text
     tgname     | tgenabled
----------------+-----------
 trg_archive    | O
 trg_check_age  | O
 trg_log_insert | O
 trg_log_status | O
 trg_normalize  | O
```

`NOT tgisinternal` прибирає службові тригери, якими PostgreSQL перевіряє
зовнішні ключі. `O` (латинська літера, від *origin*) означає, що тригер
увімкнено, `D` (*disabled*) – вимкнено. У psql те саме видно командою
`\d animals`: наприкінці її виводу є розділ `Triggers:` з повними
визначеннями.

Тимчасово вимкнути тригер, наприклад на час масового завантаження даних,
можна, не видаляючи його:

```sql
ALTER TABLE animals DISABLE TRIGGER trg_check_age;
INSERT INTO animals (name, species, age) VALUES ('Сірко', 'собака', -1);
ALTER TABLE animals ENABLE TRIGGER trg_check_age;

UPDATE animals SET status = 'вибув' WHERE name = 'Сірко';
```

```text
ERROR:  Вік не може бути від'ємним: -1
CONTEXT:  PL/pgSQL function prevent_negative_age() line 4 at RAISE
```

Поки тригер вимкнено, дані записуються як є: Сірко з віком −1 потрапив у
таблицю. Повторне ввімкнення наявних рядків не перевіряє, тож Сірко там
лишається. Але кожен наступний `UPDATE` цього рядка знову запускає
`BEFORE`-тригер, а `NEW.age` у ньому дорівнює старому віку −1, тож навіть
зміна лише статусу відхиляється.

Видаляють тригер командою `DROP TRIGGER назва ON таблиця;`. Таблицю
вказувати обов’язково, бо назва тригера унікальна лише в межах таблиці.
Функцію-тригер видаляють окремо, `DROP FUNCTION`, і лише після тригера:

```sql
DROP FUNCTION normalize_name();
```

```text
ERROR:  cannot drop function normalize_name() because other objects depend on it
DETAIL:  trigger trg_normalize on table animals depends on function normalize_name()
HINT:  Use DROP ... CASCADE to drop the dependent objects too.
```

## 9. Типові помилки

**Нескінченна рекурсія.** Рекурсією називають ситуацію, коли дія запускає
сама себе. Якщо тригер на `UPDATE` таблиці сам виконує `UPDATE` тієї ж
таблиці, кожна зміна запускає тригер знову:

```sql
CREATE FUNCTION bump() RETURNS TRIGGER AS $$
BEGIN
    UPDATE animals SET age = age + 1 WHERE id = NEW.id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_bump AFTER UPDATE ON animals
FOR EACH ROW EXECUTE FUNCTION bump();

UPDATE animals SET age = 4 WHERE id = 1;
```

```text
ERROR:  stack depth limit exceeded
HINT:  Increase the configuration parameter "max_stack_depth" (currently 2048kB), after ensuring the platform's stack depth limit is adequate.
```

(Після `HINT` psql друкує довгий `CONTEXT` з ланцюжком однакових викликів
`bump()`.) Кожен незавершений виклик PostgreSQL тримає в пам’яті (у так
званому стеку), поки місце не закінчиться. Збільшувати `max_stack_depth`
не треба: помилка в самому тригері. Команду скасовано, вік Мурки не
змінився. Тригер обов’язково видаліть, інакше кожен наступний `UPDATE`
таблиці `animals` завершуватиметься цією помилкою:
`DROP TRIGGER trg_bump ON animals;`. Щоб змінити поточний рядок,
використовують `BEFORE`-тригер і присвоєння `NEW.колонка := ...`
(розділ 7), а не повторний `UPDATE`.

**Прихована логіка.** Тригер виконується непомітно для того, хто пише
запит: за текстом `INSERT` не видно, що відбудеться ще щось. Тому кожен
тригер варто документувати, а його поведінку не робити надто складною.
Тригер доречний для журналу змін, архіву і перевірок, яких не вміє
`CHECK`; основну бізнес-логіку краще тримати у функціях і процедурах, що
викликаються явно.

**Тригер, що сповільнює масові операції.** Рядковий тригер виконує
функцію для кожного рядка. Вимірювання на базі ветклініки (psql,
`\timing on`; кожен запуск у транзакції з `ROLLBACK`, інші тригери
вимкнено):

```sql
INSERT INTO animals (name, species, age)
SELECT 'Тест', 'кіт', 1 FROM generate_series(1, 1000000);
```

| Тригери на `animals` | Час вставки мільйона рядків |
|---|---|
| без тригерів | 1,9 с |
| журнал `FOR EACH ROW` (`trg_log_insert`) | 6,3 с, і мільйон записів у журналі |
| перевірка віку, клички й журнал (три рядкові тригери) | 8,8 с |
| лише `FOR EACH STATEMENT` (`trg_import`, нижче) | 1,9 с |

`generate_series(1, 1000000)` – вбудована функція, що видає числа від 1
до мільйона. На іншому комп’ютері числа будуть інші, але різниця в кілька
разів лишиться. Для масових завантажень тригер тимчасово вимикають
(розділ 8; поки він вимкнений, немає ні перевірок, ні журналу) або
використовують тригер `FOR EACH STATEMENT`, що спрацьовує один раз на всю
команду, хоч скільки рядків вона змінила:

```sql
CREATE TABLE import_log (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    note TEXT,
    logged_at TIMESTAMP DEFAULT now()
);

CREATE FUNCTION log_import() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO import_log (note) VALUES ('додано тварин');
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_import AFTER INSERT ON animals
FOR EACH STATEMENT EXECUTE FUNCTION log_import();

INSERT INTO animals (name, species, age)
VALUES ('Рижик', 'кіт', 1), ('Тотошка', 'собака', 3), ('Шарик', 'собака', 2);

SELECT id, note FROM import_log;
```

```text
INSERT 0 3
 id |     note
----+---------------
  1 | додано тварин
```

У тригері `FOR EACH STATEMENT` змінні `NEW` і `OLD` дорівнюють `NULL`:
тригер не знає, які саме рядки змінено. Тому журнал окремих рядків він не
замінить, а годиться для записів на рівні всієї команди, як «імпорт
виконано». Результат `AFTER`-тригера ігнорується, тож `RETURN NULL` тут
безпечний. (Для довідки: усі змінені рядки такий тригер може отримати як
таблицю, `REFERENCING NEW TABLE AS new_rows`, і, наприклад, порахувати їх
`SELECT COUNT(*) FROM new_rows`.)

## 10. Запитання для самоперевірки

**Які змінні доступні у функції-тригері для `INSERT`, `UPDATE` і `DELETE`?**

Для `INSERT` має зміст лише `NEW`, для `DELETE` лише `OLD` (друга змінна
дорівнює `NULL`), для `UPDATE` обидві: `OLD` – рядок до зміни, `NEW` –
після. Вид операції – у `TG_OP`.

**Чи заблокує `AFTER`-тригер з `RAISE EXCEPTION` погану вставку?**

Так. Рядок уже записано, але помилка скасовує всю команду разом з ним.
Для перевірок однаково обирають `BEFORE`: він спрацьовує раніше і може
змінити `NEW`.

**Коли для перевірки досить `CHECK`, а коли потрібен тригер?**

`CHECK` – для умов одного рядка (`age >= 0`). Тригер – коли умова
зачіпає інші таблиці (статус тварини для візиту) або інші рядки.

**Чим відрізняється `AFTER UPDATE OF status` від `AFTER UPDATE`?**

Перший варіант спрацьовує лише на команди, які згадують колонку `status` у
`SET`. Другий спрацьовує на будь-який `UPDATE` таблиці.

**Що відбудеться, якщо `BEFORE INSERT`-тригер поверне `NULL`?**

Рядок не буде вставлено, і помилки при цьому не виникне; решта рядків
команди вставиться. Для звичайної роботи тригер має повертати `NEW`.

**Чому тригер, який усередині виконує `UPDATE` власної таблиці, небезпечний?**

Кожен такий `UPDATE` знову запускає той самий тригер. Виникає рекурсія,
яка завершується помилкою `stack depth limit exceeded`.

**Як тимчасово вимкнути тригер, не видаляючи його?**

Командою `ALTER TABLE таблиця DISABLE TRIGGER назва_тригера;`, а після
завершення роботи – `ENABLE TRIGGER`. Рядки, записані за цей час, при
ввімкненні не перевіряються.

## Підсумок

- Тригер – це функція, що повертає `TRIGGER`, і команда `CREATE TRIGGER`,
  яка прив’язує її до `INSERT`, `UPDATE` чи `DELETE` конкретної таблиці.
  Спершу функція, потім тригер; пишемо `EXECUTE FUNCTION`.
- У функції-тригері `NEW` – рядок після зміни, `OLD` – до зміни, `TG_OP` –
  назва операції; у `FOR EACH STATEMENT` `NEW` і `OLD` дорівнюють `NULL`.
- `BEFORE`-тригер перевіряє й змінює рядок до запису. `RAISE EXCEPTION` і
  в `BEFORE`, і в `AFTER` скасовує всю команду, тож заблокована зміна не
  потрапляє в журнал; номери `IDENTITY` при цьому витрачаються.
- `CHECK` – для умов одного рядка; тригер – коли умова зачіпає інші рядки
  чи таблиці.
- `AFTER UPDATE OF колонка` разом із `WHEN (OLD.x IS DISTINCT FROM NEW.x)`
  залишає в журналі лише справжні зміни; у тригері на `DELETE` дані
  беруть з `OLD` і повертають `OLD`.
- `RETURN NULL` у `BEFORE`-тригері мовчки пропускає рядок; функція без
  `RETURN` дає помилку; `UPDATE` власної таблиці в тригері – рекурсія.
- `DISABLE`/`ENABLE TRIGGER` вимикають і вмикають тригер, `DROP TRIGGER
  ... ON таблиця` видаляє. Рядковий тригер на мільйоні рядків працює в
  кілька разів повільніше; `FOR EACH STATEMENT` спрацьовує раз на команду.

Цією лекцією завершується модуль 4 і весь курс: від першого `CREATE
TABLE` у SQLite до тригерів у PostgreSQL. Далі – практика 24 і
диференційований залік.

**Практика до цієї лекції:** [Практика 24. Реалізація тригерів](../practice/24-triggers.md)

## Рекомендована література

Павловський В. І., Петрашенко А. В., Победа Д. В. *Бази даних та засоби управління. Практикум.* – Київ: КПІ ім. Ігоря Сікорського, 2021 ([відкритий доступ](https://ela.kpi.ua/server/api/core/bitstreams/1b620029-0db7-4e2e-83e7-32f7722a69be/content)). Розділ «Stored Procedures & Triggers» – створення тригерів у PostgreSQL.

Ужгородський національний університет, інженерно-технічний факультет (уклад.). *Організація баз даних: Робота з базами даних. Методичні вказівки і завдання до лабораторних робіт.* – Ужгород: ДВНЗ «Ужгородський національний університет», 2021 ([відкритий доступ](https://www.uzhnu.edu.ua/en/infocentre/get/42933)). Лабораторна робота 5 – тригери в Microsoft SQL Server: `AFTER`/`INSTEAD OF` і віртуальні таблиці `INSERTED`/`DELETED`. Синтаксис інший, ніж у PostgreSQL: замість `INSERTED`/`DELETED` тут `NEW` і `OLD`, а дію задає окрема функція-тригер. Корисно для порівняння, але приклади звідти в PostgreSQL не виконаються.
