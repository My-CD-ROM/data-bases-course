# Практика 5 — звіт (Варіант 6: Готель)

## Завдання 1 — NOT NULL (guests.phone)
Помилка при спробі вставити гостя без телефону:

Runtime error: NOT NULL constraint failed: guests.phone


## Завдання 2 — UNIQUE (guests.email)
Помилка при спробі вставити повторний email:

Runtime error: UNIQUE constraint failed: guests.email


## Завдання 3 — CHECK (rooms.capacity > 0)
Порушення: `INSERT` з `capacity = -1` →

Runtime error: CHECK constraint failed: capacity > 0

Без порушення: `INSERT` з `capacity = 2` виконався успішно.

## Завдання 4 — DEFAULT (rooms.status = 'вільний')
Вставлено рядок без вказання `status`. Перевірка:

SELECT type, status FROM rooms WHERE type = 'пентхаус';
пентхаус|вільний

Підтверджено: підставилось саме очікуване значення за замовчуванням.

## Завдання 5 — перевірка через UPDATE
Порушення CHECK через оновлення існуючого рядка:

UPDATE rooms SET capacity = 0 WHERE type = 'одномісний';
Runtime error: CHECK constraint failed: capacity > 0

Обмеження CHECK діє однаково і при INSERT, і при UPDATE — SQLite перевіряє його на кожній операції запису.

## Завдання 6 — обґрунтування кожного обмеження
- **NOT NULL (guests.phone)**: телефон — обов'язковий контакт для підтвердження й супроводу бронювання, без нього неможливо зв'язатися з гостем.
- **UNIQUE (guests.email)**: email змістовно ідентифікує конкретну людину поза системою, тому два різні гості не повинні мати однакову адресу.
- **CHECK (rooms.capacity > 0)**: номер з нульовою чи від'ємною місткістю не має фізичного сенсу — обмеження запобігає введенню логічно неможливих даних.
- **DEFAULT (rooms.status = 'вільний')**: щойно доданий у систему номер ще ніхто не встиг зайняти, тому найприродніше початкове значення статусу — "вільний".
