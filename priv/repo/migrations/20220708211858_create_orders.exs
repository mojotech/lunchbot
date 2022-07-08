defmodule Lunchbot.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :user_id, :integer
      add :menu_id, :integer
      add :lunch_order_id, :integer

      timestamps()
    end
  end
end
