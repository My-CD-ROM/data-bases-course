# Практична робота №15
## Тема: Створення індексів та аналіз ефективності запитів

**Варіант:** 3 — база даних кінотеатру  
**Таблиця для дослідження:** `tickets`

### Мета роботи

Навчитися створювати та видаляти індекси в SQLite, аналізувати плани виконання запитів за допомогою `EXPLAIN QUERY PLAN` і порівнювати роботу запитів до та після індексування.

### Виконання роботи

#### Завдання 1. Аналіз початкового плану запиту

Для перевірки пошуку квитків за зовнішнім ключем `viewer_id` виконано запит:

```sql
EXPLAIN QUERY PLAN
SELECT * FROM tickets
WHERE viewer_id = 2;
```

Отриманий результат:

```text
(2, 0, 216, 'SCAN tickets')
```

**Пояснення:** `SCAN tickets` означає, що SQLite виконує повне сканування таблиці `tickets`, оскільки відповідний індекс ще не створений.

#### Завдання 2. Створення індексу за зовнішнім ключем

Створено індекс:

```sql
CREATE INDEX idx_tickets_viewer
ON tickets(viewer_id);
```

Для перевірки використання індексу виконано:

```sql
EXPLAIN QUERY PLAN
SELECT * FROM tickets INDEXED BY idx_tickets_viewer
WHERE viewer_id = 2;
```

Результат:

```text
(3, 0, 61, 'SEARCH tickets USING INDEX idx_tickets_viewer (viewer_id=?)')
```

**Пояснення:** замість повного сканування таблиці SQLite використовує індекс `idx_tickets_viewer` для пошуку записів за значенням `viewer_id`. Це демонструє перехід від `SCAN` до `SEARCH`.

#### Завдання 3. Створення композитного індексу

Для запиту з двома умовами фільтрації використано стовпці `viewer_id` та `hall`:

```sql
CREATE INDEX idx_tickets_viewer_hall
ON tickets(viewer_id, hall);
```

Запит для перевірки:

```sql
EXPLAIN QUERY PLAN
SELECT * FROM tickets INDEXED BY idx_tickets_viewer_hall
WHERE viewer_id = 2 AND hall = 2;
```

Результат:

```text
(3, 0, 60, 'SEARCH tickets USING INDEX idx_tickets_viewer_hall (viewer_id=? AND hall=?)')
```

**Пояснення:** композитний індекс дозволяє SQLite враховувати обидва стовпці під час пошуку. Він ефективний для запитів за парою `viewer_id` і `hall`. Порядок стовпців має значення: індекс `(viewer_id, hall)` також може використовуватися для пошуку лише за першим стовпцем `viewer_id`, але не є рівноцінним індексу, що починається з `hall`.

#### Завдання 4. Створення індексу для сортування за датою

Початковий запит:

```sql
EXPLAIN QUERY PLAN
SELECT * FROM tickets
ORDER BY purchase_date;
```

Початковий результат:

```text
(3, 0, 216, 'SCAN tickets')
(17, 0, 0, 'USE TEMP B-TREE FOR ORDER BY')
```

Створено індекс:

```sql
CREATE INDEX idx_tickets_purchase_date
ON tickets(purchase_date);
```

Після цього виконано перевірку:

```sql
EXPLAIN QUERY PLAN
SELECT * FROM tickets INDEXED BY idx_tickets_purchase_date
ORDER BY purchase_date;
```

Результат:

```text
(4, 0, 224, 'SCAN tickets USING INDEX idx_tickets_purchase_date')
```

**Пояснення:** SQLite читає записи через індекс `idx_tickets_purchase_date`, який упорядкований за датою придбання. У новому плані немає окремого кроку `USE TEMP B-TREE FOR ORDER BY`, тобто додаткове сортування не потрібне.

#### Завдання 5. Видалення індексу та перевірка

Видалено простий індекс:

```sql
DROP INDEX IF EXISTS idx_tickets_viewer;
```

Після видалення перевірено пошук за `viewer_id`:

```sql
EXPLAIN QUERY PLAN
SELECT * FROM tickets INDEXED BY idx_tickets_viewer_hall
WHERE viewer_id = 2;
```

Результат:

```text
(3, 0, 61, 'SEARCH tickets USING INDEX idx_tickets_viewer_hall (viewer_id=?)')
```

**Пояснення:** після видалення простого індексу SQLite продовжує використовувати композитний індекс `idx_tickets_viewer_hall`. Це можливо тому, що `viewer_id` є першим стовпцем композитного індексу.

Для перевірки наявних індексів використано системну таблицю `sqlite_master`:

```sql
SELECT name, sql
FROM sqlite_master
WHERE type = 'index' AND tbl_name = 'tickets'
ORDER BY name;
```

Отримано два індекси:

```text
('idx_tickets_purchase_date',
 'CREATE INDEX idx_tickets_purchase_date ON tickets(purchase_date)')

('idx_tickets_viewer_hall',
 'CREATE INDEX idx_tickets_viewer_hall ON tickets(viewer_id, hall)')
```

Отже, індекс `idx_tickets_viewer` видалено, а два інші індекси залишилися в базі даних.

### Контрольні питання

**1. Чому `EXPLAIN QUERY PLAN` показує план виконання, а не результати запиту?**

Тому що команда призначена для аналізу способу виконання SQL-запиту: вона показує, чи сканує SQLite таблицю, чи використовує індекс, а також чи потрібні додаткові операції. Вона не повертає самі рядки таблиці.

**2. Чому композитний індекс може бути ефективнішим за окремий індекс за першим стовпцем?**

Композитний індекс зберігає впорядковану інформацію за комбінацією двох стовпців. Тому він може допомогти відразу відфільтрувати записи за обома умовами, наприклад `viewer_id` і `hall`, замість додаткової перевірки другої умови після пошуку за одним полем.

**3. Чому не варто створювати індекси для кожного стовпця?**

Індекси займають додаткове місце в базі даних. Крім того, під час `INSERT`, `UPDATE` та `DELETE` SQLite має оновлювати відповідні індекси, що може сповільнювати зміну даних. Тому індекси доцільно створювати для стовпців, які часто використовуються в умовах пошуку, з'єднання або сортування.

### Висновок

Під час практичної роботи було створено простий індекс за `viewer_id`, композитний індекс за `viewer_id` і `hall`, а також індекс за `purchase_date`. За допомогою `EXPLAIN QUERY PLAN` порівняно плани виконання запитів до та після індексування. Було зафіксовано перехід від повного сканування таблиці `SCAN` до пошуку з використанням індексу `SEARCH`, а також усунення окремого кроку тимчасового сортування. Наприкінці простий індекс видалено та перевірено залишені індекси через `sqlite_master`.
