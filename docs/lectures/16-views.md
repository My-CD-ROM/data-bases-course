# Лекція 16. Подання (VIEW) і матеріалізовані подання (MATERIALIZED VIEW)

*Деякі запити доводиться писати знову і знову: тварини на обліку,
тварини з прізвищами власників, кількість прийомів. Якщо формулу
виправити в одному місці й забути в іншому, результати розійдуться.
PostgreSQL дозволяє зберегти запит один раз під іменем – як
**подання (view)** – і далі звертатися до нього, як до звичайної
таблиці. Матеріалізоване подання йде ще далі: зберігає не лише запит,
а й готовий результат.*

## База лекції: демобаза ветклініки

З цієї лекції до кінця курсу всі приклади виконуються на демобазі
ветклініки – файл
[`vet_clinic_demo.sql`](../practice/sql/22-procedures/vet_clinic_demo.sql).
Кожна лекція починається з бази, щойно завантаженої з цього файлу:
створіть порожню базу (наприклад, `vet_demo`), виконайте файл у Query
Tool, і всі виводи нижче збігатимуться з вашими.

Порівняно з лекцією 15 у таблиці `animals` з’явилася колонка `status`,
а також таблиці `vets` (лікарі) і `visits` (прийоми: яка тварина, у
якого лікаря, коли і з яким діагнозом):

```sql
CREATE TABLE animals (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    species TEXT NOT NULL,
    age INTEGER,
    status TEXT NOT NULL DEFAULT 'на обліку',
    owner_id INTEGER REFERENCES owners(id)
);
```

Дані: троє власників (Петренко, Коваль, Мельник), чотири тварини на
обліку (Мурка, Барсик, Рекс, Пушок), двоє лікарів і три прийоми. Якщо
`status` в `INSERT` не вказати, база запише значення за замовчуванням –
«на обліку». Від цього `DEFAULT` залежатиме результат прикладів
розділу 4.

Приклади йдуть один за одним на тій самій базі, тому кожен наступний
бачить зміни попередніх.

## 1. CREATE VIEW: запит, збережений під іменем

```sql
CREATE VIEW animals_active AS
SELECT id, name, species, age
FROM animals
WHERE status = 'на обліку';

SELECT * FROM animals_active;
```

```text
 id |  name  | species | age
----+--------+---------+-----
  1 | Мурка  | кіт     |   3
  2 | Барсик | кіт     |   5
  3 | Рекс   | собака  |   7
  4 | Пушок  | хом'як  |   1
```

> **Подання (view)** – збережений у базі даних запит з іменем, до якого
> звертаються як до таблиці. Власних даних подання не зберігає: його
> запит виконується щоразу, коли до подання звертаються.

Після `CREATE VIEW ім’я AS` іде звичайний `SELECT`. Подання показує
лише ті колонки, які в ньому перелічено: `status` і `owner_id` тут не
видно. У літературі той самий об’єкт називають **представленням** –
це синоніми. У pgAdmin подання з’являються в дереві: Schemas, public,
Views.

## 2. Подання завжди актуальне

Додамо пса Джека – у таблицю `animals`, а не в подання, без власника і
без статусу:

```sql
INSERT INTO animals (name, species, age) VALUES ('Джек', 'собака', 1);

SELECT * FROM animals_active WHERE name = 'Джек';
```

```text
 id | name | species | age
----+------+---------+-----
  5 | Джек | собака  |   1
```

Джек уже в поданні, хоча ми нічого не оновлювали: кожен `SELECT` з
подання заново виконує збережений запит над таблицею. Статус «на
обліку» Джек отримав з `DEFAULT`.

Місця на диску під дані подання не займає:

```sql
SELECT pg_relation_size('animals_active');
```

```text
 pg_relation_size
------------------
                0
```

## 3. Подання для складних запитів

Реєстратурі потрібен список тварин із прізвищем власника, причому
тварин без власника (Джек) теж треба показувати. Збережемо `LEFT JOIN`
і `COALESCE` один раз:

```sql
CREATE VIEW animals_with_owners AS
SELECT a.id, a.name, a.species,
       COALESCE(o.last_name, 'без власника') AS owner
FROM animals a
LEFT JOIN owners o ON o.id = a.owner_id;

SELECT * FROM animals_with_owners ORDER BY id;
```

```text
 id |  name  | species |    owner
----+--------+---------+--------------
  1 | Мурка  | кіт     | Петренко
  2 | Барсик | кіт     | Петренко
  3 | Рекс   | собака  | Коваль
  4 | Пушок  | хом'як  | Мельник
  5 | Джек   | собака  | без власника
```

Зі звичайним `JOIN` Джек зник би (чотири рядки замість п’яти): у нього
немає пари в `owners`. У поданні таку деталь пишуть один раз і
правильно.

У подання можна зберегти й підсумки – скільки разів кожна тварина була
на прийомі і коли востаннє:

```sql
CREATE VIEW animal_visits AS
SELECT a.id, a.name,
       COUNT(v.id) AS visits_count,
       MAX(v.visit_date) AS last_visit
FROM animals a
LEFT JOIN visits v ON v.animal_id = a.id
GROUP BY a.id, a.name;

SELECT * FROM animal_visits ORDER BY id;
```

```text
 id |  name  | visits_count | last_visit
----+--------+--------------+------------
  1 | Мурка  |            1 | 2026-09-02
  2 | Барсик |            0 |
  3 | Рекс   |            1 | 2026-09-15
  4 | Пушок  |            1 | 2026-10-01
  5 | Джек   |            0 |
```

Порожня клітинка в psql – це `NULL`. `COUNT(v.id)`, а не `COUNT(*)`:
після `LEFT JOIN` Барсик має один рядок з `NULL` замість прийому, і
`COUNT(*)` дав би йому 1.

З поданням працюють так само, як з таблицею: фільтрують, сортують,
групують (`GROUP BY`, `HAVING`), з’єднують з таблицями й іншими
поданнями. Тварини, які ще не були на прийомі, разом із власниками:

```sql
SELECT w.name, w.owner, v.visits_count
FROM animals_with_owners w
JOIN animal_visits v ON v.id = w.id
WHERE v.visits_count = 0;
```

```text
  name  |    owner     | visits_count
--------+--------------+--------------
 Барсик | Петренко     |            0
 Джек   | без власника |            0
```

Крім коротшого запиту, подання дає ще дві речі. Воно **ховає зайві
колонки**: стажистові можна дати доступ до `animals_with_owners`, і
телефонів власників він не побачить. І воно є **одним місцем для
змін**: якщо таблиці перебудують, виправляють лише запит подання, а
запити, що до нього звертаються, лишаються без змін.

## 4. Запис через просте подання

Додамо кішку Соню через подання `animals_active`:

```sql
INSERT INTO animals_active (name, species, age) VALUES ('Соня', 'кіт', 2);

SELECT id, name, status, owner_id FROM animals WHERE name = 'Соня';
```

```text
 id | name |  status   | owner_id
----+------+-----------+----------
  6 | Соня | на обліку |
```

Подання своїх рядків не має, тож рядок записано в таблицю `animals`.
Значення отримали лише передані колонки. Колонок `status` і `owner_id`
у поданні немає: `status` отримав `DEFAULT` «на обліку», `owner_id` –
`NULL`. Соня видна в поданні лише завдяки `DEFAULT`.

Якби `status` був без `DEFAULT`:

- `status TEXT` – Соня отримала б `NULL`: рядок у таблиці є, а в
  поданні його немає, бо `NULL = 'на обліку'` не дає `TRUE`;
- `status TEXT NOT NULL` – `INSERT` не виконався б:
  `ERROR:  null value in column "status" of relation "animals" violates not-null constraint`.

Рядок, доданий через подання, може в ньому не з’явитися навіть з
`DEFAULT`. Подання для тварин, які вибули:

```sql
CREATE VIEW animals_left AS
SELECT id, name, species, age FROM animals
WHERE status = 'вибув';

INSERT INTO animals_left (name, species, age) VALUES ('Тимко', 'кіт', 4);
-- INSERT 0 1

SELECT * FROM animals_left;
-- (0 rows)

SELECT name, status FROM animals WHERE name = 'Тимко';
```

```text
 name  |  status
-------+-----------
 Тимко | на обліку
```

Тимко в таблиці, але зі статусом з `DEFAULT`, тож подання вибулих
тварин його не показує (зате тепер показує `animals_active`). Умова
`WHERE` подання – це фільтр для читання, а не правило заповнення:
PostgreSQL не підставляє в нові рядки значення з `WHERE`. Після
`INSERT` через подання перевіряйте окремим `SELECT` із самої таблиці,
які значення отримали колонки, яких немає в поданні.

## 5. Які подання можна змінювати

Через подання, що поєднує кілька таблиць, записати не вийде:

```sql
INSERT INTO animals_with_owners (name, species) VALUES ('Бім', 'собака');
```

```text
ERROR:  cannot insert into view "animals_with_owners"
DETAIL:  Views that do not select from a single table or view are not automatically updatable.
HINT:  To enable inserting into the view, provide an INSTEAD OF INSERT trigger or an unconditional ON INSERT DO INSTEAD rule.
```

PostgreSQL не може визначити, у яку з таблиць і в які колонки писати, а
`owner` – це взагалі результат `COALESCE`. Так само з підсумками:

```sql
UPDATE animal_visits SET visits_count = 5 WHERE id = 1;
```

```text
ERROR:  cannot update view "animal_visits"
DETAIL:  Views containing GROUP BY are not automatically updatable.
```

Автоматично змінювати можна лише **просте подання**: з однієї таблиці,
без `JOIN`, без `GROUP BY` і агрегатних функцій, без `DISTINCT`, `LIMIT`
і `UNION`. Через нього працюють `INSERT`, `UPDATE` і `DELETE`, але
`UPDATE` і `DELETE` бачать лише ті рядки, які показує подання:

```sql
UPDATE animals_active SET age = 4 WHERE name = 'Мурка';
-- UPDATE 1
DELETE FROM animals_left WHERE name = 'Тимко';
-- DELETE 0: Тимка в поданні animals_left не видно
```

Тригери, згадані в `HINT`, – тема лекції 18.

## 6. Рядок зникає після UPDATE. WITH CHECK OPTION

Подання тварин на обліку разом зі статусом, через яке реєстратор
позначає, хто вибув:

```sql
CREATE VIEW active_status AS
SELECT id, name, status FROM animals
WHERE status = 'на обліку';

SELECT COUNT(*) FROM active_status;   -- 7
UPDATE active_status SET status = 'вибув' WHERE name = 'Рекс';
-- UPDATE 1
SELECT COUNT(*) FROM active_status;   -- 6
```

Рекс не видалений: у таблиці `animals` він є зі статусом «вибув» і тепер
видний у поданні `animals_left`. Але з `active_status` він зник, бо
більше не відповідає умові `WHERE`. Так само зникне й рядок, у якому
помилилися: для того, хто працює лише з поданням, запис просто пропаде.

Щоб через подання не можна було записати рядок, який з нього випаде, у
кінці подання додають `WITH CHECK OPTION`:

```sql
CREATE OR REPLACE VIEW active_status AS SELECT id, name, status FROM animals
WHERE status = 'на обліку' WITH CHECK OPTION;

UPDATE active_status SET status = 'вибув' WHERE name = 'Барсик';
```

```text
ERROR:  new row violates check option for view "active_status"
DETAIL:  Failing row contains (2, Барсик, кіт, 5, вибув, 1).
```

Нічого не змінилося: Барсик досі на обліку. Так само перевіряється
`INSERT`: якби `animals_left` мало `WITH CHECK OPTION`, Тимко з
розділу 4 туди не потрапив би (`new row violates check option for view
"animals_left"`). Якщо тварина справді вибула, статус змінюють командою
`UPDATE` до самої таблиці `animals`.

## 7. CREATE OR REPLACE VIEW і його обмеження

Змінити подання можна без `DROP VIEW` – командою «створити або
замінити». Додамо в `animals_active` номер власника:

```sql
CREATE OR REPLACE VIEW animals_active AS
SELECT id, name, species, age, owner_id
FROM animals
WHERE status = 'на обліку';

SELECT * FROM animals_active ORDER BY id;
```

```text
 id |  name  | species | age | owner_id
----+--------+---------+-----+----------
  1 | Мурка  | кіт     |   4 |        1
  2 | Барсик | кіт     |   5 |        1
  4 | Пушок  | хом'як  |   1 |        3
  5 | Джек   | собака  |   1 |
  6 | Соня   | кіт     |   2 |
  7 | Тимко  | кіт     |   4 |
```

Рекса немає – він вибув; Мурці 4 роки після `UPDATE` через подання.
Так само можна змінити умову `WHERE`.

Але PostgreSQL зіставляє колонки старого і нового подання **за
порядком**, тому нові колонки можна додавати лише в кінець:

```sql
CREATE OR REPLACE VIEW animals_active AS SELECT id, species, name, age, owner_id
FROM animals WHERE status = 'на обліку';
```

```text
ERROR:  cannot change name of view column "name" to "species"
HINT:  Use ALTER VIEW ... RENAME COLUMN ... to change name of view column instead.
```

Прибрати колонку теж не можна (`ERROR:  cannot drop columns from view`),
як і змінити її тип (`age::text` дає `cannot change data type of view
column "age" from integer to text`). Якщо подання треба перебудувати
радикально, його видаляють і створюють заново.

## 8. Залежності між поданнями

Подання може спиратися на інше подання:

```sql
CREATE VIEW young_active AS SELECT * FROM animals_active WHERE age <= 2;
DROP VIEW animals_active;
```

```text
ERROR:  cannot drop view animals_active because other objects depend on it
DETAIL:  view young_active depends on view animals_active
HINT:  Use DROP ... CASCADE to drop the dependent objects too.
```

Без `animals_active` подання `young_active` перестало б працювати,
тому PostgreSQL не видаляє його і в `DETAIL` перелічує залежні об’єкти.
Так само не видалиться таблиця `animals`: `DROP TABLE animals` перелічить
усі подання над нею і зовнішній ключ `visits`.

`DROP VIEW animals_active CASCADE` видалить і залежні подання
(`NOTICE:  drop cascades to view young_active`), тож спершу прочитайте
`DETAIL`. А от `CREATE OR REPLACE VIEW animals_active` за наявності
`young_active` виконується, якщо не порушує обмежень розділу 7. Тому
подання змінюють через `CREATE OR REPLACE`, а не через `DROP` і
`CREATE`.

## 9. MATERIALIZED VIEW: знімок, а не живий запит

```sql
CREATE MATERIALIZED VIEW animals_active_mat AS
SELECT id, name, species, age FROM animals WHERE status = 'на обліку';
-- SELECT 6: запит виконано, шість рядків збережено

INSERT INTO animals (name, species, age, owner_id) VALUES ('Ліна', 'собака', 3, 3);

SELECT (SELECT COUNT(*) FROM animals_active) AS live,
       (SELECT COUNT(*) FROM animals_active_mat) AS snapshot;
```

```text
 live | snapshot
------+----------
    7 |        6
```

> **Матеріалізоване подання (materialized view)** – подання, яке
> зберігає результат свого запиту на диску як знімок. Дані в ньому
> змінюються лише тоді, коли знімок оновлюють командою
> `REFRESH MATERIALIZED VIEW`.

Під час читання матеріалізоване подання запит не виконує, тому читається
швидко, але Ліни не бачить. Оновлення:

```sql
REFRESH MATERIALIZED VIEW animals_active_mat;

SELECT (SELECT COUNT(*) FROM animals_active) AS live,
       (SELECT COUNT(*) FROM animals_active_mat) AS snapshot;
```

```text
 live | snapshot
------+----------
    7 |        7
```

Нові дані з’являються в матеріалізованому поданні в момент `REFRESH`, а
не в момент `INSERT`. Знімок займає місце на диску:

```sql
SELECT pg_relation_size('animals_active') AS view_size,
       pg_relation_size('animals_active_mat') AS mat_size;
```

```text
 view_size | mat_size
-----------+----------
         0 |     8192
```

Записувати в матеріалізоване подання не можна:
`INSERT INTO animals_active_mat ...` дає
`ERROR:  cannot change materialized view "animals_active_mat"`.
Подання, створене з `WITH NO DATA`, до першого `REFRESH` не читається
(`materialized view ... has not been populated`).

## 10. Матеріалізоване подання для підсумків. REFRESH і CONCURRENTLY

Знімок зазвичай роблять не з копії рядків, а з **підсумків**, які дорого
рахувати щоразу. Звіт для керівника: скільки прийомів провів кожен
лікар і коли останній:

```sql
CREATE MATERIALIZED VIEW vet_stats AS
SELECT v.id, v.name,
       COUNT(vi.id) AS visits_count,
       MAX(vi.visit_date) AS last_visit
FROM vets v
LEFT JOIN visits vi ON vi.vet_id = v.id
GROUP BY v.id, v.name;

SELECT * FROM vet_stats ORDER BY id;
```

```text
 id |    name     | visits_count | last_visit
----+-------------+--------------+------------
  1 | Олена Бойко |            2 | 2026-10-01
  2 | Ігор Савчук |            1 | 2026-09-15
```

Новий прийом: Барсик у хірурга Савчука.

```sql
INSERT INTO visits (animal_id, vet_id, visit_date, diagnosis)
VALUES (2, 2, '2026-10-20', 'огляд');
SELECT * FROM vet_stats ORDER BY id;   -- у Савчука досі 1 прийом

REFRESH MATERIALIZED VIEW vet_stats;
SELECT * FROM vet_stats ORDER BY id;
```

```text
 id |    name     | visits_count | last_visit
----+-------------+--------------+------------
  1 | Олена Бойко |            2 | 2026-10-01
  2 | Ігор Савчук |            2 | 2026-10-20
```

Вбудованого планувальника в PostgreSQL немає: `REFRESH` запускають
вручну або за розкладом зовнішньою програмою (системний cron,
розширення pg_cron). `REFRESH` щоразу перераховує весь запит, а не лише
змінені рядки.

Звичайний `REFRESH` на час перебудови **блокує читання** подання. Якщо
в одному вікні Query Tool виконати `REFRESH MATERIALIZED VIEW vet_stats`
у незавершеній транзакції, то в другому:

```sql
SET lock_timeout = '1s';
SELECT * FROM vet_stats ORDER BY id;
```

```text
ERROR:  canceling statement due to lock timeout
```

`REFRESH MATERIALIZED VIEW CONCURRENTLY` будує новий знімок поруч зі
старим і переносить лише відмінності; читачі весь цей час бачать старий
знімок. Для цього потрібен унікальний індекс, без нього:

```sql
REFRESH MATERIALIZED VIEW CONCURRENTLY vet_stats;
```

```text
ERROR:  cannot refresh materialized view "public.vet_stats" concurrently
HINT:  Create a unique index with no WHERE clause on one or more columns of the materialized view.
```

```sql
CREATE UNIQUE INDEX ON vet_stats (id);
REFRESH MATERIALIZED VIEW CONCURRENTLY vet_stats;
-- виконується; SELECT з іншого вікна читає без очікування
```

`id` лікаря в кожному рядку звіту різний; ім’я гірше, бо може
повторитися. Звичайний, не унікальний індекс не підійде.

## 11. Звичайне чи матеріалізоване. Видалення подань

Вибір зводиться до одного питання: чи можна показувати дані із
запізненням заради швидкості?

| | `VIEW` | `MATERIALIZED VIEW` |
|---|---|---|
| Що зберігає | лише текст запиту | результат на диску |
| Свіжість даних | завжди актуальні | на момент останнього `REFRESH` |
| Запис | через просте подання | неможливий |
| Типове застосування | скоротити запит, сховати колонки | дорогі підсумки, які часто читають |

Для кожного виду – своя команда видалення:

```sql
DROP VIEW young_active;
DROP MATERIALIZED VIEW animals_active_mat;

DROP VIEW vet_stats;
```

```text
ERROR:  "vet_stats" is not a view
HINT:  Use DROP MATERIALIZED VIEW to remove a materialized view.
```

Навпаки так само: `DROP MATERIALIZED VIEW` для звичайного подання
відповідає `is not a materialized view` з підказкою `DROP VIEW`.
`CREATE OR REPLACE` для матеріалізованого подання немає:
`CREATE OR REPLACE VIEW vet_stats ...` дає `"vet_stats" is not a view`,
тож його видаляють і створюють заново. Таблиці `DROP` не чіпає: в
`animals` так само вісім тварин.

Перелік подань – у системних каталогах:

```sql
SELECT viewname FROM pg_views WHERE schemaname = 'public';
SELECT matviewname FROM pg_matviews;
```

## 12. Запитання для самоперевірки

**Чи займає звичайне подання місце на диску під власні дані?**

Ні, воно зберігає лише текст запиту (`pg_relation_size` = 0). Дані
щоразу читаються з базових таблиць.

**Чому рядок, доданий через подання, може в ньому не з’явитися?**

Колонки, яких немає в поданні, отримують `DEFAULT` або `NULL`, а не
значення з умови `WHERE`. Якщо новий рядок не відповідає умові,
подання його не показує.

**Чому `INSERT` у подання, що поєднує дві таблиці через `JOIN`, не
виконується?**

PostgreSQL не знає, у яку таблицю й колонки записувати значення. Такі
подання автоматично доступні лише для читання.

**Що додає `WITH CHECK OPTION` до простого подання?**

Забороняє вставляти чи змінювати рядки так, щоб вони перестали
відповідати умові `WHERE` подання. Без нього змінений рядок просто
зникає з подання.

**Чому `DROP VIEW` на подання, яке використовує інше подання,
завершується помилкою?**

Залежне подання перестало б працювати. Видалити обидва разом можна
командою `DROP VIEW ... CASCADE`; змінити подання, не видаляючи
залежних, – через `CREATE OR REPLACE VIEW`.

**Матеріалізоване подання показує вчорашні дані. Як це виправити?**

Виконати `REFRESH MATERIALIZED VIEW`. Щоб оновлення не блокувало
читачів, потрібен унікальний індекс і варіант `CONCURRENTLY`.

## Підсумок

- Подання – збережений запит під іменем (синонім – представлення);
  власних даних не має і щоразу показує актуальний стан таблиць.
- У поданні зручно сховати `LEFT JOIN`, `COALESCE`, підсумки й зайві
  колонки; з поданням працюють, як з таблицею.
- Через просте подання (одна таблиця, без `JOIN`, `GROUP BY`,
  `DISTINCT`) можна виконувати `INSERT`, `UPDATE` і `DELETE`; колонки
  поза поданням отримують `DEFAULT` або `NULL`, а не значення з `WHERE`.
- Записаний через подання рядок може в ньому не з’явитися або зникнути
  з нього після `UPDATE`; `WITH CHECK OPTION` такі записи забороняє.
- `CREATE OR REPLACE VIEW` змінює запит і додає колонки лише в кінець;
  від подання можуть залежати інші, тоді `DROP` – лише з `CASCADE`.
- Матеріалізоване подання – знімок на диску; оновлюється лише
  командою `REFRESH`, яка блокує читання; `CONCURRENTLY` не блокує, але
  потребує унікального індексу.

**Практика до цієї лекції:** [Практика 20. Створення та застосування Views у PostgreSQL](../practice/20-views.md)

## Рекомендована література

Ужгородський національний університет, інженерно-технічний факультет (уклад.). *Організація баз даних: Робота з базами даних. Методичні вказівки і завдання до лабораторних робіт.* – Ужгород: ДВНЗ «Ужгородський національний університет», 2021 ([відкритий доступ](https://www.uzhnu.edu.ua/en/infocentre/get/42933)). Лабораторна робота 5 – CREATE VIEW, вкладені представлення.
