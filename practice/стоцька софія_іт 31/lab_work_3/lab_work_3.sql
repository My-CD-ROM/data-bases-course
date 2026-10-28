erDiagram
    medicines ||--o{ sales : "продаються в"
    customers ||--o{ sales : "здійснюють"

    medicines {
        int id PK
        string name
        string manufacturer
        string form
        real price
        int stock_quantity
    }

    customers {
        int id PK
        string last_name
        string first_name
        string phone
        string discount_card
    }

    sales {
        int id PK
        int medicine_id FK
        int customer_id FK
        date sale_date
        int quantity
        string payment_type
    }