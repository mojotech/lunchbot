# lunchbot

Below is the database model for Lunchbot displayed using mermaid.js. You can modify the model by making changes in this .md file.

```mermaid
  erDiagram
    MENUS {
        int id
        string name
        int office_id FK
    }
    MENU_CATEGORIES {
      int menu_id FK
      int category_id FK
    }
    CATEGORIES {
      int id
      string name
    }
    OFFICE_LUNCH_ORDERS {
        int id
        date day
        int office_id FK
    }
    OFFICES {
      int id
      string timezone
      string name
    }
    USERS {
      int id
      string email
      string role
      string name
    }
    ORDERS {
      int id
      int user_id FK
      int menu_id FK
      int office_lunch_order_id FK
    }
    ORDER_ITEMS {
        int id
        int order_id FK
        int item_id FK
    }
    ITEMS {
      int id
      string name
      int category_id
      string image_url
      boolean deleted
      int price
    }
    ITEM_OPTION_HEADINGS {
      int id
      int item_id FK
      int option_heading_id FK
    }
    OPTION_HEADINGS {
      int id
      string name
      int priority
    }
    OPTIONS {
      int id
      string name
      int option_heading_id FK
      boolean extras
      int price
      int extra_price
      boolean is_required
    }
    ORDER_ITEM_OPTIONS {
        int id
        int order_item_id FK
        int option_id FK
    }
    OFFICES ||--|{ MENUS: has
    OFFICES ||--|{ OFFICE_LUNCH_ORDERS: has
    OFFICE_LUNCH_ORDERS ||--o{ ORDERS : has
    USERS |o--|{ ORDERS: has
    MENUS ||--o{ ORDERS : has
    CATEGORIES |o--|{ ITEMS: contains
    MENUS ||--o{ MENU_CATEGORIES : has
    MENU_CATEGORIES }o--|| CATEGORIES : belongs
    ORDERS ||--o{ ORDER_ITEMS : belong
    ITEMS ||--o{ ORDER_ITEMS : belong
    ORDER_ITEMS ||--o{ ORDER_ITEM_OPTIONS : belong
    OPTIONS ||--o{ ORDER_ITEM_OPTIONS : belong
    ITEMS ||--|{ ITEM_OPTION_HEADINGS: has
    OPTION_HEADINGS ||--|{ OPTIONS: has
    OPTION_HEADINGS ||--|{ ITEM_OPTION_HEADINGS: has
```
