# Звіт до Практичної роботи №19
**Варіант 8. Служба доставки їжі. PostgreSQL 16, база `delivery_db`**

Перенесено три таблиці: `restaurants` (вимір 1), `clients` (вимір 2), `orders` (фактова).

## Завдання 1. Створення бази

У pgAdmin створено базу даних `delivery_db` (правий клік на Databases → Create → Database), Query Tool відкрито саме на ній.

## Завдання 2. Переклад CREATE TABLE

Відмінності від SQLite, які довелося врахувати:
- `INTEGER PRIMARY KEY` замінено на `INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY`;
- `PRAGMA foreign_keys` не потрібна, обидва `FOREIGN KEY` у `orders` (на `restaurants` з `ON DELETE RESTRICT` і на `clients` з `ON DELETE SET NULL`) працюють одразу;
- згенеровані стовпці `orders` з Практики 18 оголошено як `STORED`: у PostgreSQL 16 `VIRTUAL` не підтримується (помилка `syntax error at or near "VIRTUAL"`);
- у формулі `ROUND(price::numeric * 1.1, 2)` потрібне приведення до `numeric`: без нього PostgreSQL повертає `function round(double precision, integer) does not exist`.

Таблиці створено в порядку: обидва виміри, потім фактова.

## Завдання 3. Перенесення даних

Кожну таблицю експортовано з SQLite у CSV із рядком заголовків. Для `orders` у файл не включено згенеровані колонки `price_with_service` і `is_delivered`, бо в PostgreSQL вони обчислюються самі. Імпорт виконано через Import/Export Data у pgAdmin (формат csv, на вкладці Options увімкнено Header) у порядку `restaurants` → `clients` → `orders`. Імпортовано 4, 4 і 8 рядків. Порожнє значення `client_id` у замовленні 6 імпортувалось як `NULL`, а похідні колонки порахувались автоматично (наприклад, для замовлення 1: `price_with_service = 132.00`, `is_delivered = true`).

## Завдання 4. Виправлення лічильника id

Рядки імпортовано з явними `id`, тому лічильник лишився на початку. Виконано:
```sql
SELECT setval(pg_get_serial_sequence('restaurants', 'id'), (SELECT MAX(id) FROM restaurants));  -- 4
SELECT setval(pg_get_serial_sequence('clients', 'id'), (SELECT MAX(id) FROM clients));          -- 4
SELECT setval(pg_get_serial_sequence('orders', 'id'), (SELECT MAX(id) FROM orders));            -- 8
```
Перевірочні `INSERT` без явного `id` отримали `id = 5` (restaurants), `5` (clients) і `9` (orders), тобто лічильник продовжив нумерацію, а не повторив уже зайняте значення.

## Завдання 5. Перевірка цілісності

| Таблиця | SQLite до перенесення | PostgreSQL | Різниця |
|---|---|---|---|
| `restaurants` | 4 | 5 | +1 тестовий рядок |
| `clients` | 4 | 5 | +1 тестовий рядок |
| `orders` | 8 | 9 | +1 тестовий рядок |

З урахуванням тестових рядків із Завдання 4 числа збігаються.

Свідома помилка: `INSERT` у `orders` з `restaurant_id = 9999`. Точний текст помилки PostgreSQL:
```
ERROR:  insert or update on table "orders" violates foreign key constraint "orders_restaurant_id_fkey"
DETAIL:  Key (restaurant_id)=(9999) is not present in table "restaurants".
```
Спостереження: невдала вставка все одно «витрачає» номер із лічильника, тому наступний вдалий `INSERT` в `orders` отримав `id = 11`, а не `10`.

## Контрольні питання

**1. Чим PostgreSQL як клієнт-серверна СУБД відрізняється від SQLite і яка в ньому ієрархія об'єктів?**
SQLite це одна бібліотека, а база лежить в одному файлі, до якого програма звертається напряму, без окремого процесу. PostgreSQL це сервер, що працює постійно, а клієнти (pgAdmin, програми) підключаються до нього через мережу, мають власних користувачів і права. Ієрархія об'єктів: сервер → база даних → схема (за замовчуванням `public`) → таблиця.

**2. Чому `GENERATED ALWAYS AS IDENTITY`, а не `SERIAL`, і чим вони відрізняються по суті?**
`IDENTITY` входить у стандарт SQL, а `SERIAL` це скорочений запис PostgreSQL, який «під капотом» створює послідовність і прописує її як значення за замовчуванням. Головна практична різниця в захисті: з `GENERATED ALWAYS` вручну вставити `id` не можна. Перевірено: `INSERT ... (id, ...) VALUES (100, ...)` дає `cannot insert a non-DEFAULT value into column "id"`, і лише з `OVERRIDING SYSTEM VALUE` вставка проходить. Для `SERIAL` такого захисту немає, тож `id` легко випадково задати вручну й зіткнутись з лічильником. (Масовий імпорт через `COPY`, як у pgAdmin, явні `id` записує, тому після нього й потрібен `setval`.)

**3. Чому таблиці-виміри переносять перед фактовою?**
Фактова таблиця `orders` має зовнішні ключі на `restaurants` і `clients`. Якщо імпортувати `orders` першою, посилатися буде ні на що, і PostgreSQL відхилить рядки з помилкою зовнішнього ключа. Тому спершу створюються й заповнюються виміри.

**4. Що сталося б, якби пропустити Завдання 4, і на якому кроці була б помилка?**
Лічильник лишився б на початку (на 1), хоча рядки з `id` 1–4 уже є. Перший же `INSERT` без явного `id` спробував би взяти `id = 1` і впав би з помилкою. Перевірено на окремій тестовій базі: `ERROR: duplicate key value violates unique constraint "restaurants_pkey"` з `DETAIL: Key (id)=(1) already exists.` Тобто помилка виникла б саме на першому перевірочному `INSERT` у Завданні 4.

**5. Для чого потрібні pgAdmin і Query Tool і аналогами яких інструментів DB Browser for SQLite вони є?**
pgAdmin це графічний клієнт для керування сервером PostgreSQL: створення баз і таблиць, перегляд даних, імпорт і експорт. Аналог усього DB Browser for SQLite. Query Tool це вікно для написання й виконання SQL-запитів, аналог вкладки Execute SQL у DB Browser.

**6. Чому в PostgreSQL для перевірки зовнішніх ключів більше не потрібна `PRAGMA foreign_keys`?**
У SQLite перевірка зовнішніх ключів історично вимкнена за замовчуванням і вмикається окремо для кожного з'єднання. У PostgreSQL оголошений `FOREIGN KEY` перевіряється завжди, незалежно від налаштувань з'єднання, тому спроба вставити `restaurant_id = 9999` одразу дає помилку без жодної додаткової команди.
