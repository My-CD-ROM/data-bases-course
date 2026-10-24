# Лекція 18. Тригери (Triggers) у PostgreSQL

*Функції (Лекція 17) і процедури (Практики 22-23) виконуються, коли їх
явно ВИКЛИКАЄ хтось — `SELECT` чи `CALL`. Але іноді потрібно, щоб дія
відбувалась автоматично, сама, щоразу коли в таблиці щось змінюється —
без жодного окремого виклику. Для цього в PostgreSQL є **тригер**:
функція, яка виконується сама, "прив'язана" до `INSERT`/`UPDATE`/
`DELETE` конкретної таблиці.*

## 1. Функція-тригер: RETURNS TRIGGER, NEW і OLD

У прикладах тригери пишуть журнал змін у таблицю `animal_log` (таку саму створюють на Практиці 24):

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

```sql
CREATE OR REPLACE FUNCTION log_status_change() RETURNS TRIGGER AS $$
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

Тригер завжди складається з двох частин: спеціальної функції, що
повертає тип `TRIGGER` (а не звичайний тип, як у Лекції 17), і самого
`CREATE TRIGGER` (розділ 2), що прив'язує цю функцію до таблиці.
Усередині функції-тригера доступні спеціальні змінні: `NEW` — рядок
ПІСЛЯ зміни (для `INSERT`/`UPDATE`), `OLD` — рядок ДО зміни (для
`UPDATE`/`DELETE`), і `TG_OP` — текст типу операції (`'INSERT'`,
`'UPDATE'`, `'DELETE'`), що дозволяє одній функції обробляти кілька
видів подій по-різному.

## 2. CREATE TRIGGER — прив'язка функції до таблиці

```sql
CREATE TRIGGER trg_log_status
AFTER INSERT OR UPDATE ON animals
FOR EACH ROW
EXECUTE FUNCTION log_status_change();
```

`AFTER INSERT OR UPDATE ON таблиця FOR EACH ROW EXECUTE FUNCTION
ім'я_функції();` — тригер спрацьовує ПІСЛЯ (`AFTER`) кожного
(`FOR EACH ROW`) `INSERT` чи `UPDATE` над таблицею `animals`.
Після `INSERT` нового рядка в `animal_log` автоматично
з'являється запис `('INSERT', NULL, 'на обліку')`, а після подальшого
`UPDATE` статусу ще один запис `('UPDATE', 'на обліку', 'вибув')`,
без жодного окремого виклику, лише завдяки самому факту зміни
таблиці `animals`.

## 3. BEFORE-тригер: перевірка й блокування операції

```sql
CREATE OR REPLACE FUNCTION prevent_negative_age() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.age < 0 THEN
        RAISE EXCEPTION 'Вік не може бути від'ємним: %', NEW.age;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_age
BEFORE INSERT OR UPDATE ON animals
FOR EACH ROW
EXECUTE FUNCTION prevent_negative_age();
```

```sql
INSERT INTO animals (name, age, status) VALUES ('Помилка', -3, 'на обліку');
```

```text
ERROR: Вік не може бути від'ємним: -3
```

`BEFORE` (замість `AFTER`) означає: тригер спрацьовує ДО того, як
зміна фізично застосується — і якщо функція-тригер викликає `RAISE
EXCEPTION`, сама операція `INSERT`/`UPDATE` скасовується цілком,
рядок не потрапляє в таблицю. Спроба вставити тварину з
від'ємним віком заблокована, кількість рядків у таблиці не зростає.
Це схоже на `CHECK` (Лекція 6), але потужніше: тригер може перевіряти
й складнішу логіку, що зачіпає інші рядки чи навіть інші таблиці,
тоді як `CHECK` бачить лише значення одного рядка.

## 4. AFTER проти BEFORE — коли яке

`BEFORE` використовують для валідації й можливої відмови (як у
розділі 3) чи для модифікації самого значення `NEW` перед записом.
`AFTER` використовують, коли зміна вже точно відбулась і потрібна
похідна дія — типово, логування (розділ 2) чи оновлення пов'язаних
даних в іншій таблиці. Обидва — `FOR EACH ROW` у прикладах цієї
лекції: тригер спрацьовує окремо для КОЖНОГО зміненого рядка, а не
один раз на весь запит.

## 5. Журнал, що пише зайве: умови спрацювання

Тригер `trg_log_status` із розділу 2 спрацьовує після **кожного** `UPDATE` таблиці `animals`, навіть якщо статус не змінився. Перевіримо на двох тваринах. Щоб нумерація збігалася з виводом нижче, почнемо з порожніх таблиць: додамо тварин, змінимо статус одній, а потім збільшимо вік обом:

```sql
TRUNCATE animals, animal_log RESTART IDENTITY;

INSERT INTO animals (name, species, age, status)
VALUES ('Мурка', 'кіт', 3, 'на обліку'), ('Рекс', 'собака', 7, 'на обліку');

UPDATE animals SET status = 'вибув' WHERE name = 'Рекс';
UPDATE animals SET age = age + 1;

SELECT animal_id, action, old_status, new_status FROM animal_log ORDER BY id;
```

```text
 animal_id | action | old_status | new_status
-----------+--------+------------+------------
         1 | INSERT |            | на обліку
         2 | INSERT |            | на обліку
         2 | UPDATE | на обліку  | вибув
         1 | UPDATE | на обліку  | на обліку
         2 | UPDATE | вибув      | вибув
```

Два останні рядки журналу зайві: змінився вік, а не статус, але в журналі з'явились записи «статус став таким самим». З часом такий журнал розростається й перестає бути корисним. Тригеру можна вказати два уточнення прямо в `CREATE TRIGGER`:

```sql
CREATE TRIGGER trg_status_only
AFTER UPDATE OF status ON animals
FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status)
EXECUTE FUNCTION log_status_change();
```

`UPDATE OF status` означає, що тригер реагує лише на команди, які **згадують** колонку `status` у `SET`. Умова `WHEN (...)` додатково відсікає випадки, коли значення записали, але воно не змінилось. Оператор `IS DISTINCT FROM` порівнює значення, правильно обробляючи `NULL` (звичайне `<>` із `NULL` дало б невизначений результат). Перед створенням нового тригера старий видаляють командою `DROP TRIGGER trg_log_status ON animals;`, інакше обидва писатимуть у журнал. Новий тригер реагує лише на `UPDATE`, тому для журналювання вставок знадобиться окремий тригер `AFTER INSERT ON animals ... EXECUTE FUNCTION log_status_change();` без `WHEN`: в одному тригері з `INSERT` умову `WHEN` із посиланням на `OLD` PostgreSQL не дозволяє. Тепер команда `UPDATE animals SET age = age + 1` запису в журнал не залишає, а реальний перехід статусу `'вибув'` у `'на обліку'` додає один запис:

```text
 animal_id | action | old_status | new_status
-----------+--------+------------+------------
         2 | UPDATE | вибув      | на обліку
```

Повторна команда, що виставляє той самий статус `'на обліку'`, нового запису не створює.

## 6. Тригер на видалення і змінна OLD

Для `INSERT` у функції-тригері доступний лише `NEW`, а для `DELETE` лише `OLD`: нового рядка при видаленні немає. Це дозволяє зберегти копію видаленого запису в архіві:

```sql
CREATE TABLE animals_archive (
    id         INTEGER,
    name       TEXT,
    species    TEXT,
    deleted_at TIMESTAMP
);

CREATE OR REPLACE FUNCTION archive_animal() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO animals_archive (id, name, species, deleted_at)
    VALUES (OLD.id, OLD.name, OLD.species, now());
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_archive
AFTER DELETE ON animals
FOR EACH ROW
EXECUTE FUNCTION archive_animal();
```

Після `DELETE FROM animals WHERE name = 'Рекс';` тварина зникає з `animals`, але її дані лишаються в `animals_archive`:

```sql
SELECT id, name, species FROM animals_archive;
```

```text
 id | name | species
----+------+---------
  2 | Рекс | собака
```

У тригері на `DELETE` повертають `OLD`, а не `NEW`: нового рядка при видаленні немає. Наш тригер має тип `AFTER`, тож значення, що повертається, ігнорується, і `RETURN NULL` спрацював би так само. Але краще звикнути повертати `OLD`, бо у `BEFORE DELETE`-тригері значення, що повертається, вирішує долю операції (розділ 7), а `RETURN NEW` там мовчки скасувало б видалення.

## 7. BEFORE-тригер: змінити рядок або тихо його скасувати

У `BEFORE`-тригері можна не лише відхилити операцію через `RAISE EXCEPTION` (розділ 3), а й **змінити** рядок, перш ніж він потрапить у таблицю. Присвоєння `NEW.колонка := значення` підмінює значення, яке буде записано. Приклад: тригер, що приводить імена тварин до єдиного вигляду:

```sql
CREATE OR REPLACE FUNCTION normalize_name() RETURNS TRIGGER AS $$
BEGIN
    NEW.name := initcap(trim(NEW.name));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_normalize
BEFORE INSERT OR UPDATE ON animals
FOR EACH ROW
EXECUTE FUNCTION normalize_name();

INSERT INTO animals (name, species, age, status)
VALUES ('   ДЖЕК  ', 'собака', 1, 'на обліку');
```

У таблицю потрапить `Джек`: пробіли обрізано, регістр вирівняно. Користувач, що вводив дані, навіть не підозрює про цю обробку, у чому водночас і користь, і небезпека тригерів.

Значення, що повертає `BEFORE`-тригер, має наслідки. `RETURN NEW` означає «продовжуй». А `RETURN NULL` означає «пропусти цей рядок»: операція **мовчки скасовується** без помилки.

```sql
CREATE OR REPLACE FUNCTION skip_all() RETURNS TRIGGER AS $$
BEGIN
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_skip BEFORE INSERT ON animals
FOR EACH ROW EXECUTE FUNCTION skip_all();

INSERT INTO animals (name, species, age, status) VALUES ('Невидимка', 'кіт', 1, 'на обліку');
```

Команда завершується успішно, але `SELECT COUNT(*) FROM animals WHERE name = 'Невидимка'` повертає 0. Це типове джерело «зниклих» даних: якщо поставити `RETURN NULL` не там, рядки зникатимуть без жодного повідомлення. А от якщо забути `RETURN` зовсім, PostgreSQL не промовчить: вставка завершиться помилкою `control reached end of trigger procedure without RETURN`, і рядок теж не потрапить у таблицю. Після експерименту тригер варто видалити (`DROP TRIGGER trg_skip ON animals;`), інакше він скасовуватиме кожну вставку в таблицю.

## 8. Керування тригерами

Список тригерів таблиці можна отримати із системного каталогу:

```sql
SELECT tgname, tgenabled
FROM pg_trigger
WHERE tgrelid = 'animals'::regclass AND NOT tgisinternal;
```

Колонка `tgenabled` зі значенням `O` (латинська літера, від *origin*) означає, що тригер увімкнено, а `D` (*disabled*), що вимкнено. Тимчасово вимкнути тригер, наприклад на час масового імпорту даних, можна, не видаляючи його:

```sql
ALTER TABLE animals DISABLE TRIGGER trg_normalize;
-- ... завантаження даних ...
ALTER TABLE animals ENABLE TRIGGER trg_normalize;
```

Поки тригер вимкнено, дані записуються як є: у нашому прикладі ім'я `'  мур  '` потрапило б у таблицю з пробілами. Видаляють тригер командою `DROP TRIGGER trg_normalize ON animals;`, у якій, на відміну від `DROP FUNCTION`, потрібно вказати таблицю, бо назва тригера унікальна лише в межах таблиці. Саму функцію-тригер після цього видаляють окремо.

## 9. Типові помилки

**Нескінченна рекурсія.** Рекурсією називають ситуацію, коли дія запускає сама себе. Якщо тригер на `UPDATE` таблиці сам виконує `UPDATE` тієї ж таблиці, кожна зміна запускає тригер знову:

```sql
CREATE OR REPLACE FUNCTION bump() RETURNS TRIGGER AS $$
BEGIN
    UPDATE animals SET age = age + 1 WHERE id = NEW.id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_bump AFTER UPDATE ON animals
FOR EACH ROW EXECUTE FUNCTION bump();

UPDATE animals SET age = 1 WHERE name = 'Мурка';
```

```text
ERROR:  stack depth limit exceeded
```

Після експерименту тригер обов'язково видаліть, інакше кожен наступний `UPDATE` таблиці `animals` завершуватиметься помилкою: `DROP TRIGGER trg_bump ON animals;`.

Тригер викликає сам себе, і кожен незавершений виклик PostgreSQL тримає в пам'яті (у так званому стеку), поки місце не закінчиться. Для зміни значень поточного рядка використовують `BEFORE`-тригер і присвоєння `NEW.колонка := ...`, а не повторний `UPDATE`.

**Прихована логіка.** Тригер виконується непомітно для того, хто пише запит: за текстом `INSERT` не видно, що відбудеться ще щось. Тому кожен тригер варто документувати, а його поведінку не робити надто складною. На практиці тригер доречний для журналу змін і простих перевірок, а основну бізнес-логіку краще тримати у функціях і процедурах, що викликаються явно.

**Тригер, що сповільнює масові операції.** Для кожного зміненого рядка виконується функція. Вставка мільйона рядків у таблицю з тригером означає мільйон викликів функції. Для таких операцій тригер тимчасово вимикають (розділ 8) або використовують варіант `FOR EACH STATEMENT`, що спрацьовує один раз на всю команду, незалежно від кількості змінених рядків. У такому тригері немає змінних `NEW` і `OLD`, тож журнал по кожному рядку він не веде; він годиться для дій на рівні всієї команди, наприклад запису «імпорт виконано».

## 10. Запитання для самоперевірки

**Які змінні доступні у функції-тригері для `INSERT`, `UPDATE` і `DELETE`?**

Для `INSERT` доступний лише `NEW`, для `DELETE` лише `OLD`, для `UPDATE` обидва: `OLD` містить рядок до зміни, `NEW` після. Вид операції можна дізнатись із `TG_OP`.

**Чим відрізняється `AFTER UPDATE OF status` від `AFTER UPDATE`?**

Перший варіант спрацьовує лише на команди, які згадують колонку `status` у `SET`. Другий спрацьовує на будь-який `UPDATE` таблиці.

**Що відбудеться, якщо `BEFORE INSERT`-тригер поверне `NULL`?**

Рядок не буде вставлено, і помилки при цьому не виникне. Для звичайної роботи тригер має повертати `NEW`.

**Чому тригер, який усередині виконує `UPDATE` власної таблиці, небезпечний?**

Кожен такий `UPDATE` знову запускає той самий тригер. Виникає рекурсія, яка завершується помилкою `stack depth limit exceeded`.

**Як тимчасово вимкнути тригер, не видаляючи його?**

Командою `ALTER TABLE таблиця DISABLE TRIGGER назва_тригера;`, а після завершення роботи `ENABLE TRIGGER`.

## Підсумок

- Тригер = функція, що повертає `TRIGGER` (зі спеціальними змінними
  `NEW`/`OLD`/`TG_OP`) + `CREATE TRIGGER`, що прив'язує цю функцію до
  `INSERT`/`UPDATE`/`DELETE` конкретної таблиці.
- `AFTER`-тригер спрацьовує після зміни — типово для логування чи
  похідних дій; `BEFORE`-тригер спрацьовує до зміни й може заблокувати
  операцію через `RAISE EXCEPTION`, якщо дані не проходять перевірку.
- `FOR EACH ROW` означає: тригер виконується окремо для кожного
  зміненого рядка.
- Тригер автоматизує реакцію на зміну таблиці — на відміну від функцій
  і процедур (Лекція 17, Практики 22-23), його ніхто явно не викликає, він
  спрацьовує сам.
- `AFTER UPDATE OF колонка` разом із `WHEN (...)` обмежує спрацювання тригера лише потрібними змінами.
- `BEFORE`-тригер може змінювати `NEW`, а `RETURN NULL` мовчки скасовує операцію; тригер, що оновлює власну таблицю, спричиняє рекурсію.

Цією лекцією завершується Модуль 4 і весь курс: від першого `CREATE
TABLE` у SQLite (Лекція 2) до автоматичних тригерів у PostgreSQL — та
сама тритаблична схема вашого варіанта пройшла через увесь шлях.

**Практика до цієї лекції:** [Практика 24. Реалізація тригерів](../practice/24-triggers.md)

## Рекомендована література

Ужгородський національний університет, інженерно-технічний факультет (уклад.). *Організація баз даних: Робота з базами даних. Методичні вказівки і завдання до лабораторних робіт.* — Ужгород: ДВНЗ «Ужгородський національний університет», 2021 ([відкритий доступ](https://www.uzhnu.edu.ua/en/infocentre/get/42933)). Лабораторна робота 5 — тригери AFTER/INSTEAD OF, віртуальні таблиці INSERTED/DELETED.

Павловський В. І., Петрашенко А. В., Победа Д. В. *Бази даних та засоби управління. Практикум.* — Київ: КПІ ім. Ігоря Сікорського, 2021 ([відкритий доступ](https://ela.kpi.ua/server/api/core/bitstreams/1b620029-0db7-4e2e-83e7-32f7722a69be/content)). Розділ «Stored Procedures & Triggers» — створення тригерів у PostgreSQL.
