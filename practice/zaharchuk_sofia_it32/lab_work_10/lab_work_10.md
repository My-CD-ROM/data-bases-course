# Практика 10 - звіт (Варіант 6: Готель)

## Завдання 1
Межу COUNT(*) > 1 обрано, бо номер, якого бронювали лише один раз, ще не показує стійкого попиту; потрібні номери, які бронюють повторно.

## Завдання 3
WHERE rooms.capacity >= 2 відсіює окремі рядки: бронювання одномісних номерів до групування. HAVING COUNT(bookings.id) >= 2 відсіює вже готові групи: номери, яких бронювали менше двох разів.

## Завдання 4
Помилка SQLite: misuse of aggregate: COUNT(). WHERE виконується до GROUP BY, на цьому кроці груп ще не існує, тому агрегат COUNT(*) нема від чого рахувати.

## Завдання 5
LEFT JOIN потрібен, бо номер без жодного бронювання має потрапити в результат з COUNT = 0. INNER JOIN прибрав би такий номер ще до GROUP BY, і HAVING його ніколи б не побачив.



# Розбір усіх прикладів HAVING

## Головна ідея

`GROUP BY` збирає рядки в **групи** (наприклад, усі бронювання одного номера). `HAVING` потім **відсіює цілі групи** за результатом агрегатної функції.

- `WHERE` фільтрує окремі рядки **до** групування.
- `HAVING` фільтрує готові групи **після** групування.

Порядок виконання: `FROM → WHERE → GROUP BY → HAVING → SELECT`.

---

## 1. HAVING на COUNT

```sql
SELECT room_id, COUNT(*) AS кількість
FROM bookings
GROUP BY room_id
HAVING COUNT(*) > 1;
```

1. `GROUP BY room_id` розкладає бронювання по групах: одна група на кожен номер.
2. `COUNT(*)` рахує, скільки бронювань у кожній групі.
3. `HAVING COUNT(*) > 1` лишає тільки ті групи, де бронювань більше одного.

Результат: номери, які бронювали **повторно**. Номер із одним бронюванням зникає з відповіді.

```sql
SELECT guest_id, COUNT(*) AS кількість
FROM bookings
GROUP BY guest_id
HAVING COUNT(*) >= 2;
```

Те саме, але групи за гостями. Результат: гості, які бронювали два рази й більше (постійні клієнти).

---

## 2. HAVING на AVG / SUM / MIN / MAX

HAVING працює з будь-якою агрегатною функцією, не лише з COUNT.

```sql
SELECT status, AVG(price_per_night) AS середня_ціна
FROM rooms
GROUP BY status
HAVING AVG(price_per_night) > 1500;
```

Групуємо номери за статусом ("вільний", "зайнятий", "на прибиранні"), рахуємо середню ціну в кожній групі й лишаємо тільки статуси, де вона вища за 1500.

```sql
SELECT type, SUM(price_per_night) AS сума
FROM rooms
GROUP BY type
HAVING SUM(price_per_night) > 2000;
```

Групи за типом номера, у кожній сума цін. Лишаємо типи із сумою понад 2000.

```sql
SELECT status, MAX(price_per_night) AS макс_ціна
FROM rooms
GROUP BY status
HAVING MAX(price_per_night) < 3000;
```

Лишаємо статуси, де навіть найдорожчий номер коштує менше 3000.

```sql
SELECT status, MIN(capacity) AS мін_місткість
FROM rooms
GROUP BY status
HAVING MIN(capacity) >= 2;
```

Лишаємо статуси, де **навіть найменший** номер вміщує 2 людини й більше. Тобто всі номери цієї групи мають місткість від 2.

---

## 3. HAVING через JOIN

```sql
SELECT guests.last_name, COUNT(bookings.id) AS кількість
FROM guests
JOIN bookings ON bookings.guest_id = guests.id
GROUP BY guests.id
HAVING COUNT(bookings.id) >= 2;
```

1. `JOIN` з'єднує гостя з його бронюваннями, щоб замість `guest_id` показати прізвище.
2. `GROUP BY guests.id` дає одну групу на гостя. Групуємо за `id`, а не за прізвищем, бо прізвища можуть повторюватись.
3. `HAVING` лишає гостей, у яких два бронювання й більше.

Це `INNER JOIN`, тому гості без жодного бронювання тут і так не з'являються.

```sql
SELECT guests.last_name, AVG(rooms.price_per_night) AS середня_ціна
FROM bookings
JOIN rooms ON bookings.room_id = rooms.id
JOIN guests ON bookings.guest_id = guests.id
GROUP BY guests.id
HAVING AVG(rooms.price_per_night) > 1500;
```

Три таблиці разом. Для кожного гостя беремо ціни номерів, які він бронював, і рахуємо середнє. Лишаємо тих, хто бронює в середньому дорогі номери (понад 1500).

---

## 4. WHERE + GROUP BY + HAVING разом

```sql
SELECT room_id, COUNT(*) AS кількість
FROM bookings
WHERE check_in_date >= '2026-09-05'
GROUP BY room_id
HAVING COUNT(*) >= 2;
```

Це два різні фільтри на двох різних етапах:

1. `WHERE check_in_date >= '2026-09-05'` відкидає **окремі бронювання**, які почалися раніше цієї дати. Вони навіть не потраплять у групи.
2. `GROUP BY room_id` групує те, що лишилось.
3. `HAVING COUNT(*) >= 2` відкидає **групи**, де лишилось менше двох бронювань.

Результат: номери, які з 5 вересня бронювали щонайменше двічі.

```sql
SELECT type, COUNT(*) AS кількість
FROM rooms
WHERE status = 'вільний'
GROUP BY type
HAVING COUNT(*) >= 1;
```

`WHERE` лишає тільки вільні номери, `GROUP BY` групує їх за типом.

Зауваження: тут `HAVING COUNT(*) >= 1` **нічого не відсіює**. Група утворюється лише з наявних рядків, тож у ній завжди хоча б один рядок. Для змістовного прикладу краще писати `HAVING COUNT(*) >= 2` (типи, яких вільних номерів два й більше). На захисті краще показувати саме такий варіант.

---

## 5. Псевдонім у HAVING

```sql
SELECT room_id, COUNT(*) AS кількість
FROM bookings
GROUP BY room_id
HAVING кількість > 1;
```

`AS кількість` дає імʼя результату `COUNT(*)`, а в `HAVING` можна написати `кількість` замість `COUNT(*)`. Це особливість SQLite: `HAVING` бачить псевдоніми зі `SELECT`. Використати той самий псевдонім у `WHERE` не вийде, бо `WHERE` виконується до того, як агрегат обчислено.

---

## 6. LEFT JOIN + HAVING (включно з нулями)

```sql
SELECT rooms.type, COUNT(bookings.id) AS кількість
FROM rooms
LEFT JOIN bookings ON bookings.room_id = rooms.id
GROUP BY rooms.id
HAVING COUNT(bookings.id) < 2;
```

`LEFT JOIN` бере **всі** номери, навіть без бронювань. Для такого номера поля `bookings` стають `NULL`, а `COUNT(bookings.id)` дає `0`. `HAVING < 2` лишає номери, яких бронювали менше двох разів, **разом із тими, яких не бронювали взагалі**. З `INNER JOIN` номери без бронювань зникли б іще до групування.

```sql
SELECT guests.last_name, COUNT(bookings.id) AS кількість
FROM guests
LEFT JOIN bookings ON bookings.guest_id = guests.id
GROUP BY guests.id
HAVING COUNT(bookings.id) = 0;
```

Знаходить гостей, які ще **жодного разу не бронювали**.

Тут важливо писати саме `COUNT(bookings.id)`, а не `COUNT(*)`. `COUNT(*)` порахував би навіть "порожній" рядок, який `LEFT JOIN` створив для гостя без бронювань, і дав би 1 замість 0. `COUNT(bookings.id)` пропускає `NULL`, тому дає чесний 0. Це часте питання на захисті.

---

## 7. Навмисна помилка

```sql
SELECT room_id, COUNT(*)
FROM bookings
WHERE COUNT(*) > 1
GROUP BY room_id;
```

Результат: `misuse of aggregate: COUNT()`.

`WHERE` виконується **до** `GROUP BY`. На цьому етапі груп ще немає, тож `COUNT(*)` нема від чого рахувати. Виправлення: замінити `WHERE` на `HAVING` і поставити його **після** `GROUP BY`.

---

## Що сказати на захисті одним реченням

> `WHERE` відбирає рядки до групування, `HAVING` відбирає групи після групування, тому тільки в `HAVING` можна ставити умову на `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`.