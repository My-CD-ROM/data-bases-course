# Практична робота №5

Тема: Обмеження цілісності даних: NOT NULL, UNIQUE, CHECK, DEFAULT.  
Виконав: Лазарев Ілля 
Група: IT-31  
Варіант: 7 — Спортзал (фітнес-клуб).

## Мета
Додати обмеження до наявних таблиць SQLite через перестворення, зберегти дані та перевірити INSERT і UPDATE.

## Початковий стан
Використано базу з практичної №4: memberships, clients, membership_sales. Оскільки birth_date вже мало NOT NULL, додатковим підготовчим перестворенням його тимчасово знято, а в завданні 1 додано повторно. Це навчальна демонстрація; початкові дані й id збережено.

## Завдання 1. NOT NULL
Таблицю clients перестворено з birth_date TEXT NOT NULL. Вставка клієнта без birth_date відхилена. Точний текст SQLite, отриманий через Python sqlite3:

```text
NOT NULL constraint failed: clients.birth_date
```

## Завдання 2. UNIQUE
До phone таблиці clients додано UNIQUE, попередні обмеження збережено. Вставка з номером клієнта id=1 відхилена:

```text
UNIQUE constraint failed: clients.phone
```

## Завдання 3. CHECK
До price таблиці memberships додано CHECK (price > 0). Ціна -100 відхилена:

```text
CHECK constraint failed: price > 0
```

Вставка з ціною 1400 виконалася успішно. Тестовий запис прибрано через ROLLBACK.

## Завдання 4. DEFAULT
Таблицю memberships перестворено з duration_days INTEGER NOT NULL DEFAULT 30, зберігши CHECK для price. Під час вставки вказано тільки type і price. SELECT підтвердив:

| type | duration_days | price |
|---|---:|---:|
| Тестовий місячний | 30 | 1400.0 |

DEFAULT автоматично підставив 30. Тестовий запис прибрано через ROLLBACK.

## Завдання 5. UPDATE
Виконано UPDATE memberships SET price=-50 WHERE id=1. Отримано:

```text
CHECK constraint failed: price > 0
```

Ціна разового абонемента залишилася 150. Обмеження CHECK однаково діє при INSERT та UPDATE.

## Завдання 6. Обґрунтування
1. NOT NULL для birth_date потрібне, оскільки за правилами цієї моделі дата народження обов’язкова для визначення вікової категорії клієнта.
2. UNIQUE для phone потрібне, оскільки в цій моделі кожна картка клієнта має окремий номер телефону.
3. CHECK (price > 0) потрібне, оскільки платний абонемент повинен мати додатну ціну.
4. DEFAULT 30 для duration_days потрібне, оскільки типовий абонемент у цій моделі діє 30 днів.

## Збереження даних та зв’язків
Збережено 6 абонементів, 6 клієнтів, 10 продажів. Зовнішні ключі membership_sales залишилися незмінними: membership_id → memberships.id з ON DELETE RESTRICT; client_id → clients.id з ON DELETE SET NULL. Перед заміною таблиць перевірку FK вимкнено до BEGIN, після COMMIT увімкнено знову. PRAGMA foreign_keys повернула 1, foreign_key_check не повернула рядків, integrity_check повернула ok.

## Контрольні питання
1. SQLite не підтримує ALTER TABLE ADD CONSTRAINT для наявних колонок; потрібно створити нову таблицю, перенести дані, видалити стару й перейменувати нову.
2. Якщо серед наявних значень є NULL, перенесення в колонку з NOT NULL завершиться помилкою. Дані потрібно виправити перед міграцією, а невдалу транзакцію відкотити.
3. CHECK після перестворення діє так само, як CHECK, оголошений при початковому створенні таблиці.
4. DEFAULT перевіряють вставкою без відповідної колонки та SELECT. Явно переданий NULL не замінюється на DEFAULT і порушить NOT NULL, якщо воно є.

## Висновок
Використано CREATE TABLE, INSERT INTO SELECT, DROP TABLE, ALTER TABLE, BEGIN, COMMIT, ROLLBACK, SELECT, UPDATE та PRAGMA. Застосовано й перевірено NOT NULL, UNIQUE, CHECK і DEFAULT зі збереженням даних та зовнішніх ключів.
