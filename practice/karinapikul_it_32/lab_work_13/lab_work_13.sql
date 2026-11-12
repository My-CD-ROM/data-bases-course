# Практична робота №13. 

## Завдання 1. Форматування ціни за допомогою printf()

SELECT
    type,
    price AS original_price,
    printf('%.2f грн', price) AS formatted_price
FROM memberships;

**Результат:**

| type | original_price | formatted_price |
| Разовий | 200.0 | 200.00 грн |
| Тижневий | 200.0 | 200.00 грн |
| Місячний | 200.0 | 200.00 грн |
| Квартальний | 200.0 | 200.00 грн |
| Піврічний | 200.0 | 200.00 грн |
| Річний | 200.0 | 200.00 грн |
| Пробний | 200.0 | 200.00 грн |
| Тестовий | 200.0 | 200.00 грн |
| VIP | 200.0 | 200.00 грн |

## Завдання 2. Форматування з використанням ширини поля

SELECT
    type,
    printf('%8.2f грн', price) AS formatted_price
FROM memberships;

**Результат:** для кожного з дев'яти абонементів отримано `  200.00 грн` (із пробілами перед числом).

## Завдання 3. Зміщення дати на 30 днів

SELECT
    id,
    purchase_date,
    date(purchase_date, '+30 days') AS new_date
FROM membership_sales;

**Результат:**

| id | purchase_date | new_date |
| 2 | 2026-09-02 | 2026-10-02 |
| 3 | 2026-09-03 | 2026-10-03 |
| 5 | 2026-09-06 | 2026-10-06 |
| 6 | 2026-09-07 | 2026-10-07 |
| 7 | 2026-09-08 | 2026-10-08 |
| 9 | 2026-09-11 | 2026-10-11 |

## Завдання 4. Групування покупок за місяцями

SELECT
    strftime('%Y-%m', purchase_date) AS month,
    COUNT(*) AS sales_count
FROM membership_sales
GROUP BY strftime('%Y-%m', purchase_date);

**Результат:**

| month | sales_count |
| 2026-09 | 6 |

## Завдання 5. Перевірка некоректної дати

SELECT
    'not-a-date' AS original_date,
    strftime('%Y', 'not-a-date') AS extracted_year;

**Результат:**

| original_date | extracted_year |
| not-a-date | NULL |