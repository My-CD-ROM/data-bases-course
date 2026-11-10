# Звіт до Практичної роботи №5
**Варіант 8. Служба доставки їжі**

## Завдання 1. NOT NULL

Стовпець `clients.full_name` до цього не мав жодного обмеження, крім `PRIMARY KEY` у таблиці. Змістовно клієнт без імені — некоректний запис, тому додано `NOT NULL` через перестворення таблиці:

```sql
PRAGMA foreign_keys = OFF;
ALTER TABLE clients RENAME TO clients_old;
CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    phone TEXT
);
INSERT INTO clients SELECT * FROM clients_old;
DROP TABLE clients_old;
PRAGMA foreign_keys = ON;
```

Перевірка (вставка без `full_name`):
```
INSERT INTO clients (id, phone) VALUES (5, '+380671110000');
```
Точний текст помилки:
```
Error: NOT NULL constraint failed: clients.full_name
```

**Технічне зауваження**: оскільки `clients` — таблиця, на яку посилається зовнішній ключ `orders.client_id` (з `ON DELETE SET NULL`), перестворення виконувалось при тимчасово вимкненому `PRAGMA foreign_keys`. Якщо цього не зробити, `DROP TABLE clients_old` трактується SQLite як видалення всіх її рядків і реально запускає дію `ON DELETE SET NULL` для всіх замовлень, що посилались на цих клієнтів, — усі `client_id` в `orders` передчасно обнулилися б ще до Завдання 5.

## Завдання 2. UNIQUE

Стовпець `clients.phone` за змістом має бути унікальним ідентифікатором клієнта — два різні клієнти не можуть мати один номер телефону. Перестворено таблицю ще раз (так само з тимчасово вимкненою `PRAGMA foreign_keys`), додавши `UNIQUE`:

```sql
CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    phone TEXT UNIQUE
);
```

Перевірка (вставка номера, що вже є в базі):
```
INSERT INTO clients (id, full_name, phone) VALUES (5, 'Тестовий Клієнт', '+380501112233');
```
Точний текст помилки:
```
Error: UNIQUE constraint failed: clients.phone
```

## Завдання 3. CHECK

Стовпець `orders.price` — числовий, і змістовно ціна страви не може бути нульовою чи від'ємною. Додано `CHECK (price > 0)`:

```sql
ALTER TABLE orders RENAME TO orders_old;
CREATE TABLE orders (
    ...
    price REAL CHECK (price > 0),
    ...
);
INSERT INTO orders SELECT * FROM orders_old;
DROP TABLE orders_old;
```

Перевірка 1 (порушення, від'ємна ціна):
```
INSERT INTO orders (restaurant_id, client_id, dish_name, price, order_date)
VALUES (1, 1, 'Тестова страва', -50.00, '2026-09-05');
```
Помилка:
```
Error: CHECK constraint failed: price > 0
```

Перевірка 2 (коректне значення, 159.00) — виконалась без помилок, рядок додано.

## Завдання 4. DEFAULT

Стовпець `orders.status` отримав значення за замовчуванням `'Нове'` разом із `NOT NULL` — кожне нове замовлення логічно повинно починати життєвий цикл зі статусу "Нове", якщо оператор не вказав інший явно.

```sql
CREATE TABLE orders (
    ...
    status TEXT NOT NULL DEFAULT 'Нове',
    ...
);
```

Перевірка — вставка рядка без вказівки `status`:
```
INSERT INTO orders (restaurant_id, client_id, dish_name, price, order_date)
VALUES (3, 3, 'Піца Гавайська', 210.00, '2026-09-07');
```
Підтвердження через SELECT:
```sql
SELECT id, dish_name, status FROM orders WHERE dish_name = 'Піца Гавайська';
```
Результат: `(7, 'Піца Гавайська', 'Нове')` — значення підставилося автоматично, як і очікувалось.

## Завдання 5. Порушення через UPDATE

Обрано обмеження `CHECK (price > 0)` з Завдання 3 і порушено його не через `INSERT`, а через `UPDATE` наявного рядка:

```sql
UPDATE orders SET price = -10.0 WHERE id = 1;
```
Точний текст помилки:
```
Error: CHECK constraint failed: price > 0
```
Це підтверджує, що обмеження `CHECK` діє однаково і при вставці нового рядка, і при оновленні вже наявного — SQLite перевіряє умову для кожного рядка, що потрапляє в таблицю в результаті будь-якої операції запису, а не лише в момент `INSERT`.

## Завдання 6. Обґрунтування обмежень

- **NOT NULL (`clients.full_name`)** — запис про клієнта без імені не має сенсу для служби доставки: неможливо звернутися до людини чи підписати замовлення на конкретного отримувача.
- **UNIQUE (`clients.phone`)** — номер телефону слугує фактичним ідентифікатором клієнта в системі; дублікати призвели б до плутанини при повторному оформленні замовлень і ускладнили б зв'язок кур'єра з клієнтом.
- **CHECK (`orders.price > 0`)** — ціна страви є основою для розрахунків і оплати; нульове чи від'ємне значення суперечить бізнес-логіці замовлення та могло б виникнути лише як помилка введення.
- **DEFAULT (`orders.status = 'Нове'`)** — кожне замовлення в момент створення завжди перебуває на початковій стадії обробки, тож підстановка цього значення автоматично прибирає потребу вказувати його вручну щоразу і виключає порожні/помилкові статуси.
