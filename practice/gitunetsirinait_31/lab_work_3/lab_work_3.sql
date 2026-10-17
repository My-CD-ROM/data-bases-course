erDiagram
    rooms {
        int id PK
        string type
        float price_per_night
        int capacity
        string status
    }
    clients {
        int id PK
        string full_name
        string phone
        string email
    }
    bookings {
        int id PK
        int room_id FK "→ rooms(id)"
        int client_id FK "→ clients(id)"
        string check_in_date
        string check_out_date
        float total_price
    }
    rooms ||--o{ bookings : "містить"
    clients ||--o{ bookings : "здійснює"