# Практика 9 — звіт (Варіант 6: Готель)

## Завдання 1 — пояснення
Кожен рядок результату означає один номер (за room_id) і кількість разів, скільки цей номер бронювали за весь час спостереження.

## Завдання 4 — пояснення кількості рядків
Кількість рядків результату GROUP BY за (type, status) дорівнює кількості УНІКАЛЬНИХ КОМБІНАЦІЙ цих двох колонок, а не сумі чи добутку окремих кількостей унікальних значень type і status. Наприклад, навіть якщо є 7 унікальних типів і 3 унікальні статуси, реальних комбінацій у даних може бути менше за 7×3=21, бо не кожен тип обов'язково зустрічається з кожним статусом одночасно.

## Завдання 5 — пояснення
Запит з колонкою guests.last_name поза GROUP BY і без агрегатної функції виконався в SQLite БЕЗ ПОМИЛКИ. При повторному запуску значення цієї колонки могло відрізнятися (чи збігтися випадково) - SQLite підставляє прізвище з якогось одного, довільного рядка кожної групи, і не гарантує, який саме рядок буде обраний. На це значення покладатися не можна: стандарт SQL і, зокрема, PostgreSQL вважають такий запит помилкою й просто відхилять його виконання, оскільки неможливо однозначно визначити, яке значення показати для колонки, що не входить у групування.




## Групування за однією колонкою

```sql
SELECT status, COUNT(*) FROM rooms GROUP BY status;
```

```sql
SELECT guest_id, COUNT(*) FROM bookings GROUP BY guest_id;
```

## Групування за кількома колонками

```sql
SELECT type, status, COUNT(*) FROM rooms GROUP BY type, status;
```

```sql
SELECT room_id, guest_id, COUNT(*) FROM bookings GROUP BY room_id, guest_id;
```

## GROUP BY + агрегатна функція (не COUNT)

```sql
SELECT status, AVG(price_per_night) FROM rooms GROUP BY status;
```

```sql
SELECT status, SUM(price_per_night) FROM rooms GROUP BY status;
```

```sql
SELECT status, MIN(price_per_night), MAX(price_per_night) FROM rooms GROUP BY status;
```

## GROUP BY через JOIN

```sql
SELECT guests.last_name, COUNT(bookings.id) AS кількість
FROM guests
LEFT JOIN bookings ON bookings.guest_id = guests.id
GROUP BY guests.id;
```

```sql
SELECT rooms.type, AVG(rooms.price_per_night) AS середня_ціна, COUNT(bookings.id) AS кількість
FROM rooms
LEFT JOIN bookings ON bookings.room_id = rooms.id
GROUP BY rooms.id;
```

## GROUP BY + WHERE (фільтр рядків до групування)

```sql
SELECT type, COUNT(*) FROM rooms WHERE capacity >= 2 GROUP BY type;
```

```sql
SELECT room_id, COUNT(*) FROM bookings WHERE check_in_date >= '2026-09-10' GROUP BY room_id;
```

## GROUP BY + HAVING (фільтр груп після агрегації)

```sql
SELECT room_id, COUNT(*) AS кількість FROM bookings GROUP BY room_id HAVING COUNT(*) > 1;
```

```sql
SELECT guests.last_name, COUNT(bookings.id) AS кількість
FROM guests
LEFT JOIN bookings ON bookings.guest_id = guests.id
GROUP BY guests.id
HAVING кількість >= 2;
```