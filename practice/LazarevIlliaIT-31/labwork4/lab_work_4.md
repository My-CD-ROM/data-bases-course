# Практична робота №4
## Варіант 7 — Спортзал (фітнес-клуб)
### Завдання 1
Створено таблицю clients:

id — INTEGER PRIMARY KEY
last_name — TEXT
first_name — TEXT
phone — TEXT
birth_date — TEXT

### Завдання 2
Створено таблицю membership_sales.

Зовнішні ключі:

membership_id → memberships(id)
client_id → clients(id)

Для membership_id використано ON DELETE RESTRICT, тому що
небажано видаляти тип абонемента, який уже використовувався
в історії продажів.

Для client_id використано ON DELETE CASCADE, тому що при
видаленні клієнта його пов'язані записи про покупки також
видаляються.

### Завдання 3
До таблиці clients додано 6 записів.

До таблиці membership_sales додано 10 записів.

Усі зовнішні ключі посилаються на реально існуючі записи.

### Завдання 4
Було виконано спробу додати запис із client_id = 9999,
якого немає в таблиці clients.

SQLite видала помилку:

FOREIGN KEY constraint failed

Це підтверджує, що перевірка зовнішніх ключів працює.

### Завдання 5
Створена структура відповідає ER-діаграмі з Практичної роботи №3.

Таблиця memberships пов'язана з membership_sales через
membership_id, а таблиця clients — через client_id.

Обидва зв'язки мають тип 1:N.