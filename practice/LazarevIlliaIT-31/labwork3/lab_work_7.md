erDiagram

    memberships ||--o{ membership_sales : "включена в"
    clients ||--o{ membership_sales : "оформлює"

    memberships {
        int id PK
        string type
        int duration_days
        real price
    }

    clients {
        int id PK
        string last_name
        string first_name
        string phone
        date birth_date
    }

    membership_sales {
        int id PK
        int membership_id FK
        int client_id FK
        date purchase_date
        date expiration_date
    }