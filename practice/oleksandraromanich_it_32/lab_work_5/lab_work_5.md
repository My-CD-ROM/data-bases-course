# Практика 5. Обмеження цілісності даних: NOT NULL, UNIQUE, CHECK, DEFAULT

**Варіант № 1 — Бібліотека**

**Файл бази:** `lab_work_5.db` (на основі `lab_work_4.db`, у якій уже були таблиці `books`, `readers`, `loans`).

Робота виконувалась у середовищі DB Browser for SQLite. Усі чотири обмеження додавалися методом перестворення таблиці (через `CREATE TABLE ..._new`, `INSERT INTO ..._new SELECT * FROM ...`, `DROP TABLE`, `ALTER TABLE ... RENAME`), оскільки SQLite не підтримує `ALTER TABLE ... ADD CONSTRAINT`. Під час перестворення `PRAGMA foreign_keys = OFF` вимикала перевірку зовнішніх ключів, щоб уникнути помилки `FOREIGN KEY constraint failed` при `DROP TABLE`.

---

## Завдання 1 — NOT NULL (`readers.registration_date`)

**Обраний стовпець:** `readers.registration_date` — дата реєстрації читача.

**Обґрунтування вибору:** кожен читач, який є в базі, був зареєстрований у конкретний день. Раніше стовпець мав тип `TEXT` без `NOT NULL`, тому технічно можна було вставити читача без дати. Це створювало б неконсистентні дані: неможливо порахувати реєстрації за місяць, відсортувати читачів за давністю, перевірити застарілість реєстрації.

**Перестворення таблиці:**

```sql
PRAGMA foreign_keys = OFF;

CREATE TABLE readers_new (
    id                 INTEGER PRIMARY KEY,
    last_name          TEXT NOT NULL,
    first_name         TEXT NOT NULL,
    email              TEXT UNIQUE,
    registration_date  TEXT NOT NULL
);

INSERT INTO readers_new SELECT * FROM readers;
DROP TABLE readers;
ALTER TABLE readers_new RENAME TO readers;

PRAGMA foreign_keys = ON;
```

**Перевірка — спроба вставити читача без `registration_date`:**

```sql
INSERT INTO readers (last_name, first_name, email)
VALUES ('Петренко', 'Олег', 'oleg2@example.com');
```

**Точний текст помилки (скопійовано з DB Browser):**

```
Execution finished with errors.
Result: NOT NULL constraint failed: readers.registration_date
At line 1:
INSERT INTO readers (last_name, first_name, email)
VALUES ('Петренко', 'Олег', 'oleg2@example.com');
```

**Додаткова перевірка — без `last_name`:**

```sql
INSERT INTO readers (first_name, email, registration_date)
VALUES ('Олег', 'oleg@example.com', '2025-03-01');
```

**Точний текст помилки:**

```
Execution finished with errors.
Result: NOT NULL constraint failed: readers.last_name
At line 1:
INSERT INTO readers (first_name, email, registration_date)
VALUES ('Олег', 'oleg@example.com', '2025-03-01');
```

`NOT NULL` спрацював: рядки без обов'язкових полів не потрапили в таблицю.

---

## Завдання 2 — UNIQUE (`readers.email`)

**Обраний стовпець:** `readers.email` — електронна пошта читача.

**Обґрунтування вибору:** email — це унікальний ідентифікатор особи в системі. Два різні читачі не можуть мати однаковий email — інакше неможливо однозначно ідентифікувати, хто взяв книгу, неможливо надіслати нагадування про повернення, неможливо відновити пароль. Природне правило: **один email = один читач**.

**Перестворення таблиці:** виконано разом із Завданням 1 — у тому ж `CREATE TABLE readers_new` стовпець `email` має `TEXT UNIQUE`.

**Перевірка — спроба вставити читача з email, який уже є:**

```sql
INSERT INTO readers (last_name, first_name, email, registration_date)
VALUES ('Тест-U', 'Тест', 'olena.shevchenko@library.ua', '2025-03-01');
```

**Точний текст помилки:**

```
Execution finished with errors.
Result: UNIQUE constraint failed: readers.email
At line 1:
INSERT INTO readers (last_name, first_name, email, registration_date)
VALUES ('Тест-U', 'Тест', 'olena.shevchenko@library.ua', '2025-03-01');
```

`UNIQUE` спрацював: новий рядок не додався, бо email `olena.shevchenko@library.ua` уже належить іншому читачу (id 1).

---

## Завдання 3 — CHECK (`books.publication_year` між 1000 і 2100)

**Обраний стовпець:** `books.publication_year` — рік видання книги.

**Обґрунтування вибору:** рік видання — це число з осмисленим діапазоном. Друкарство з'явилося близько 1440 року, тому рік видання не може бути, наприклад, 500 або 1000. Верхня межа 2100 — це запас на майбутнє, щоб виключити помилкові значення на кшталт 2200 або 3000, які майже завжди є наслідком помилки введення. Обмеження `CHECK (publication_year >= 1000 AND publication_year <= 2100)` гарантує, що в базі не з'явиться фізично неможливий рік.

**Перестворення таблиці:**

```sql
PRAGMA foreign_keys = OFF;

CREATE TABLE books_new (
    id                INTEGER PRIMARY KEY,
    title             TEXT NOT NULL,
    author            TEXT NOT NULL,
    publication_year  INTEGER CHECK (publication_year >= 1000 AND publication_year <= 2100),
    genre             TEXT,
    copies_count      INTEGER NOT NULL DEFAULT 1,
    UNIQUE (title, author)
);

INSERT INTO books_new SELECT * FROM books;
DROP TABLE books;
ALTER TABLE books_new RENAME TO books;

PRAGMA foreign_keys = ON;
```

**Перевірка 1 — спроба вставити книгу з роком поза діапазоном (очікується помилка):**

```sql
INSERT INTO books (title, author, publication_year, genre, copies_count)
VALUES ('Тест-C', 'Тест', 900, 'жанр', 1);
```

**Точний текст помилки:**

```
Execution finished with errors.
Result: CHECK constraint failed: publication_year >= 1000 AND publication_year <= 2100
At line 1:
INSERT INTO books (title, author, publication_year, genre, copies_count)
VALUES ('Тест-C', 'Тест', 900, 'жанр', 1);
```

**Перевірка 2 — коректна вставка (без помилки):**

```sql
INSERT INTO books (title, author, publication_year, genre, copies_count)
VALUES ('Тест-OK', 'Тест', 2020, 'жанр', 1);
```

**Результат:**

```
Execution finished without errors.
Result: query executed successfully. Took 0ms, 1 рядків постражджало
```

`CHECK` спрацював у обох випадках: некоректне значення (900) заблоковано, коректне (2020) — прийнято.

---

## Завдання 4 — DEFAULT (`books.copies_count = 1`)

**Обраний стовпець:** `books.copies_count` — кількість примірників.

**Обґрунтування вибору:** коли бібліотека додає нову книгу в каталог, вона зазвичай отримує один примірник — це найпоширеніший випадок. Якщо надійшло більше примірників, значення можна вказати явно в `INSERT`. Але в переважній більшості випадків адміністратор не повинен вручну вводити «1» — це має бути значенням за замовчуванням. Це також захищає від помилки, коли поле взагалі забули заповнити: без `DEFAULT` там був би `NULL`, а з `DEFAULT 1` — коректне значення.

**Перестворення таблиці:** виконано разом із Завданням 3 — `copies_count INTEGER NOT NULL DEFAULT 1`.

**Перевірка — вставка рядка без вказівки `copies_count`:**

```sql
INSERT INTO books (title, author, publication_year, genre)
VALUES ('Тест-D', 'Тест', 2020, 'жанр');
```

**Результат:**

```
Execution finished without errors.
Result: query executed successfully. Took 0ms, 1 рядків постражджало
```

**Перевірка підставленого значення через `SELECT`:**

```sql
SELECT id, title, copies_count FROM books WHERE title = 'Тест-D';
```

**Результат:**

```
id  | title    | copies_count
----+----------+--------------
7   | Тест-D   | 1
```

**Підтвердження:** у стовпці `copies_count` для нового рядка стоїть **1**, хоча значення не вказувалося в `INSERT`. Значення за замовчуванням спрацювало правильно.

---

## Завдання 5 — перевірка через UPDATE, а не INSERT

**Обране обмеження:** `CHECK` на `books.publication_year`.

**Порушення через `UPDATE` існуючого рядка:**

```sql
UPDATE books SET publication_year = 500 WHERE title = 'Кобзар';
```

**Точний текст помилки:**

```
Execution finished with errors.
Result: CHECK constraint failed: publication_year >= 1000 AND publication_year <= 2100
At line 1:
UPDATE books SET publication_year = 500 WHERE title = 'Кобзар';
```

**Підтвердження:** обмеження `CHECK` діє однаково як при `INSERT` (спроба вставити новий рядок із некоректним значенням), так і при `UPDATE` (спроба змінити значення в наявному рядку на некоректне). SQLite перевіряє умову `CHECK` щоразу, коли значення стовпця змінюється — незалежно від типу операції.

---

## Завдання 6 — письмовий висновок

**NOT NULL для `readers.registration_date`:**
Дата реєстрації — обов'язковий атрибут бізнес-процесу: кожен читач у базі був зареєстрований у конкретний день, і без цієї дати неможливо ані відсортувати читачів за давністю, ані порахувати статистику реєстрацій за місяць.

**UNIQUE для `readers.email`:**
Email — унікальний ідентифікатор особи в системі; два різні читачі не можуть мати однаковий email, бо тоді неможливо однозначно визначити, кому саме надсилати нагадування про повернення книги і хто саме взяв конкретний примірник.

**CHECK для `books.publication_year`:**
Рік видання — це число з осмисленим діапазоном (друкарство виникло близько 1440 року), тому значення на кшталт 500 або 3000 фізично неможливі й майже завжди є наслідком помилки введення; `CHECK` не дає таким значенням потрапити в базу.

**DEFAULT для `books.copies_count`:**
Нова книга в каталозі бібліотеки за замовчуванням надходить в одному примірнику — це найпоширеніший випадок; `DEFAULT 1` позбавляє адміністратора від ручного введення «1» у кожному рядку й захищає від помилки, коли поле взагалі забули заповнити.

---

## Контрольні питання

### 1. Чому в SQLite неможливо просто виконати `ALTER TABLE ... ADD CONSTRAINT CHECK (...)`, і що доводиться робити замість цього?

SQLite має навмисно мінімалістичний синтаксис `ALTER TABLE` — підтримує лише перейменування таблиці, перейменування стовпця і додавання стовпця. Жодної команди для додавання `CHECK`, `UNIQUE`, `NOT NULL` або `FOREIGN KEY` до вже існуючого стовпця немає. Це історичне рішення: SQLite — вбудована БД для мобільних застосунків і невеликих програм, де міграції схем зазвичай виконуються разом з оновленням застосунку.

**Стандартний рецепт перестворення таблиці:**
1. `PRAGMA foreign_keys = OFF;`
2. Створити `*_new` з обмеженнями.
3. `INSERT INTO *_new SELECT * FROM *;`
4. `DROP TABLE *;` (старі)
5. `ALTER TABLE *_new RENAME TO *;`
6. `PRAGMA foreign_keys = ON;`

У DB Browser for SQLite є графічна альтернатива: **Database Structure** → правою на таблиці → **Modify Table** — але під капотом виконується той самий рецепт.

### 2. Що станеться, якщо перестворити таблицю, додавши `NOT NULL` до стовпця, у якому серед наявних рядків уже є `NULL`?

Операція впаде з помилкою на кроці `INSERT INTO <назва>_new SELECT * FROM <назва>_old;`. SQLite спробує вставити всі наявні рядки в нову таблицю з `NOT NULL`, натрапить на перший рядок із `NULL` у зазначеному стовпці — і поверне:

```
Error: NOT NULL constraint failed: <назва>.<стовпець>
```

**Стан бази після невдачі:**
- Нова таблиця `<назва>_new` створена, але порожня (бо `INSERT` відкотився).
- Стара таблиця `<назва>_old` з усіма даними залишилася.
- Дані не втрачені, але треба вирішити, що робити з `NULL`-ами.

**Як виправити:**
1. `DROP TABLE <назва>_new;`
2. Замінити `NULL` на реальні значення: `UPDATE <назва>_old SET <стовпець> = '<значення>' WHERE <стовпець> IS NULL;`
3. Повторити рецепт перестворення.

У нашій практиці це сталося з `books.publication_year` — у таблиці залишалися рядки `Тест-CHECK` із роком 900, і `INSERT INTO books_new SELECT * FROM books` падав із `CHECK constraint failed`. Виправили через `DELETE` тестових рядків.

### 3. Чим перевірка `CHECK`, доданого через перестворення таблиці, відрізняється від перевірки `CHECK`, оголошеного одразу при `CREATE TABLE`?

**Для подальших операцій — нічим.** `CHECK` — це декларативне обмеження, яке SQLite перевіряє щоразу при будь-якій зміні рядка: і при `INSERT`, і при `UPDATE`. З точки зору рушія не має значення, чи обмеження було оголошено при першому `CREATE TABLE`, чи додано через перестворення — поведінка однакова.

**Єдина практична різниця — момент перевірки:**
- `CHECK`, оголошений при `CREATE TABLE`, перевіряє всі рядки, які вставляються з цього моменту.
- `CHECK`, доданий через перестворення, додатково перевіряє всі наявні рядки при `INSERT INTO ..._new SELECT * FROM ..._old`. Якщо в старій таблиці є рядок, що порушує новий `CHECK`, перенесення впаде з помилкою `CHECK constraint failed`.

Отже, перед перестворенням треба переконатися, що всі наявні дані задовольняють нове обмеження — або виправити їх (`UPDATE`), або видалити (`DELETE`).

### 4. Чому `DEFAULT` не можна перевірити тим самим способом, що й `NOT NULL`/`UNIQUE`/`CHECK` (спробою порушення), і як його перевіряють замість цього?

`DEFAULT` — це не обмеження, а правило підстановки значення. Воно не «забороняє» нічого — навпаки, дозволяє вставити рядок, не вказуючи значення для стовпця, і підставляє заздалегідь визначене.

| Обмеження | Що робить | Як перевірити порушенням |
|---|---|---|
| `NOT NULL` | забороняє `NULL` | вставити `NULL` → помилка |
| `UNIQUE` | забороняє дублікати | вставити існуюче значення → помилка |
| `CHECK (...)` | забороняє значення, що не пройшли умову | вставити некоректне значення → помилка |
| `DEFAULT` | підставляє значення, якщо його не вказали | неможливо — немає заборони |

Спроба «порушити» `DEFAULT` неможлива, бо `DEFAULT` спрацьовує лише тоді, коли стовпець не вказано в `INSERT`. Якщо стовпець вказано явно (навіть зі значенням, що суперечить «логіці за замовчуванням»), `DEFAULT` просто не застосовується, і жодної помилки не буде.

**Як `DEFAULT` перевіряють насправді:**
1. Вставити рядок без вказівки стовпця з `DEFAULT`:
   ```sql
   INSERT INTO books (title, author, publication_year, genre)
   VALUES ('Тест-D', 'Тест', 2020, 'жанр');
   ```
2. Виконати `SELECT` по цьому рядку:
   ```sql
   SELECT id, title, copies_count FROM books WHERE title = 'Тест-D';
   ```
3. Перевірити, що підставилось очікуване значення (`copies_count = 1`).