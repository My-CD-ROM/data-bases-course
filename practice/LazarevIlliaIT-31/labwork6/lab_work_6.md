Практична робота 6. UPDATE та DELETE

Мета роботи

Навчитися змінювати та видаляти дані в базі даних за допомогою SQL-команд UPDATE та DELETE, а також перевірити роботу зовнішніх ключів із правилами ON DELETE.

⸻

Завдання 1. UPDATE у фактованій таблиці

Для таблиці membership_sales було змінено дату завершення одного продажу абонемента.

Використано команду:

UPDATE membership_sales
SET expiration_date = '2026-10-15'
WHERE id = 1;

Після цього результат було перевірено за допомогою:

SELECT *
FROM membership_sales
WHERE id = 1;

Запис із id = 1 було успішно оновлено.

⸻

Завдання 2. UPDATE у таблиці-вимірі

Було змінено ціну одного з абонементів у таблиці memberships.

UPDATE memberships
SET price = 1200
WHERE id = 1;

Для перевірки використано:

SELECT *
FROM memberships
WHERE id = 1;

Команда UPDATE дозволяє змінити значення існуючого запису без створення нового запису.

⸻

Завдання 3. DELETE одного запису

Перед видаленням було перевірено кількість записів у таблиці membership_sales:

SELECT COUNT() AS count_before
FROM membership_sales;

Після цього було видалено один конкретний продаж:

DELETE FROM membership_sales
WHERE id = 10;

Кількість записів після видалення перевірено командою:

SELECT COUNT() AS count_after
FROM membership_sales;

До видалення в таблиці було 10 записів, після видалення залишилося 9.
Завдання 4. Перевірка ON DELETE CASCADE

У таблиці membership_sales для зовнішнього ключа client_id встановлено:

FOREIGN KEY (client_id)
REFERENCES clients(id)
ON DELETE CASCADE

Це означає, що при видаленні клієнта автоматично видаляються всі записи з membership_sales, які посилаються на цього клієнта.

Спочатку було перевірено продажі клієнта з id = 1:

SELECT *
FROM membership_sales
WHERE client_id = 1;

Після цього клієнта було видалено:

DELETE FROM clients
WHERE id = 1;

Після видалення було виконано повторну перевірку:

SELECT *
FROM membership_sales
WHERE client_id = 1;

Пов’язані записи з membership_sales також були видалені автоматично.

⸻

Висновок

Під час практичної роботи було опрацьовано команди UPDATE та DELETE.

За допомогою UPDATE було змінено дані в таблицях membership_sales та memberships. За допомогою DELETE було видалено окремий запис із таблиці продажів.

Також було перевірено роботу зовнішнього ключа з правилом ON DELETE CASCADE. При видаленні клієнта пов’язані з ним записи про продажі були видалені автоматично.

Таким чином, було отримано практичні навички зміни та видалення даних у реляційній базі даних і роботи з обмеженнями зовнішніх ключів.