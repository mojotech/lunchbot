# lunchbot

Below is the database model for Lunchbot displayed using mermaid.js. You can modify the model by making changes in this .md file.

```mermaid
  erDiagram
    MENUS ||--o{ CATEGORIES : has
    MENUS ||--o{ ORDERS : has
    MENUS {
        string name
        int id
        int office_id
    }
    OFFICE_LUNCH_ORDERS ||--o{ ORDERS : has
    OFFICE_LUNCH_ORDERS {
        int id
        date day
        int office_id FK
    }
    USER |o--|{ ORDERS: has
    USER {
      string email
      string role
      int id
    }
    ORDERS {
      int id
      int user_id FK
      int menu_id FK
      int lunch_order_id FK
    }
    ITEMS |o--|{ EXTRAS: has
    ITEMS ||--o{ ORDER_ITEMS : belongs
    ORDER_ITEMS ||--o{ ORDER_ITEM_EXTRAS : has
    ORDER_ITEMS {
        int id
        date day
        int office_id FK
    }
    OFFICES ||--|{ MENUS: has
    OFFICES ||--|{ OFFICE_LUNCH_ORDERS: has
    OFFICES {
      string timezone
      int id
    }
    CATEGORIES |o--|{ ITEMS: contains
    CATEGORIES {
      int id
      string name
      int menu_id FK
    }
    ORDERS ||--o{ ORDER_ITEMS : has
    EXTRAS ||--o{ ORDER_ITEM_EXTRAS: belongs
    ITEMS {
      int id
      string name
      int category_id
      string image_url
      boolean deleted
    }
    ORDER_ITEM_EXTRAS {
      int id
      int order_item_id
      int item_id
    }
    EXTRAS {
      int id
      string name
      int item_id
    }
```
