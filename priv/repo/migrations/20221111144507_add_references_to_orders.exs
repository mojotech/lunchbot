defmodule Lunchbot.Repo.Migrations.AddReferencesToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      modify :user_id, references(:users, on_delete: :nilify_all)
      # restrict means you can't delete menu_id if there are still orders that reference that menu
      modify :menu_id, references(:menus, on_delete: :restrict)
      modify :lunch_order_id, references(:office_lunch_orders, on_delete: :delete_all)
    end

    rename table(:orders), :lunch_order_id, to: :office_lunch_order_id

    alter table(:order_items) do
      modify :order_id, references(:orders, on_delete: :delete_all)
      modify :item_id, references(:items, on_delete: :restrict)
    end

    alter table(:order_item_options) do
      modify :order_item_id, references(:order_items, on_delete: :delete_all)
      modify :option_id, references(:options, on_delete: :restrict)
    end
  end
end
