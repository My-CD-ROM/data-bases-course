erDiagram
    movies ||--o{ tickets : "має"
    viewers ||--o{ tickets : "купує"

    movies {
        int id PK
        string title
        string genre
        int duration_min
        int year
        int age_rating
    }

    viewers {
        int id PK
        string last_name
        string first_name
        string email
        string phone
    }

    tickets {
        int id PK
        int movie_id FK
        int viewer_id FK
        string hall
        date showtime
        real price
        string seat
        date purchase_date
    }