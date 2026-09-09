Практика 3
Варіант 2 — Інтернет-магазин одягу

Завдання 1. ER-діаграма

```mermaid
erDiagram
    products ||--o{ orders : "замовлений у"
    customers ||--o{ orders : "оформлює"

    products {
        int id PK
        string name
        string category
        string size
        real price
        int stock_quantity
    }

    customers {
        int id PK
        string last_name
        string first_name
        string email
        string city
    }

    orders {
        int id PK
        int product_id FK
        int customer_id FK
        date order_date
        int quantity
        string status
    }
Завдання 2. Тип зв'язків

products — orders — 1:N, тому що один товар може бути в багатьох замовленнях.

customers — orders — 1:N, тому що один клієнт може зробити багато замовлень.

Завдання 3. PK і FK

products: PK — id, FK — немає.

customers: PK — id, FK — немає.

orders: PK — id; FK — product_id → products.id, customer_id → customers.id.

Завдання 4. Додаткова сутність

Можна додати таблицю categories(id, name, description).

categories — products — 1:N, тому що одна категорія може містити багато товарів.

Завдання 5. Порівняння

Моя схема схожа на приклад хімчистки: є дві вимірні таблиці та одна фактова таблиця з двома FK. Обидва зв'язки мають тип 1:N, а вимірні таблиці пов'язані через фактову таблицю.

Контрольні питання
1.

Концептуальна модель описує сутності та зв'язки. Логічна — таблиці, стовпці та ключі. Фізична — конкретну реалізацію в СУБД.

2.

M:N потребує окремої проміжної таблиці, яка містить FK на обидві основні таблиці.

3.

|| — один, o{ — нуль або багато, |{ — один або багато.

A ||--o{ B означає: одному A відповідає нуль або багато B.


Цього достатньо для здачі за всіма пунктами практики:contentReference[oaicite:0]{index=0}