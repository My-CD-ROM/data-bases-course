# Звіт з Практичної роботи №3
**Варіант №8:** Служба доставки їжі (Glovo)  
**Склад схеми:** `dishes` (Вимір 1), `couriers` (Вимір 2), `orders` (Фактова таблиця)

---

## Завдання 1. ER-діаграма повної схеми (Mermaid)

erDiagram
    dishes ||--o{ orders : "доставляє s1"

    dishes {
        int id PK
        string name
        string category
        real price
        string restaurant
    }

    couriers {
        int id PK
        string last_name
        string first_name
        string phone
        string transport
    }

    orders {
        int id PK
        int dish_id FK
        int courier_id FK
        date order_date
        string address
        string status
    }