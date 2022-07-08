defmodule Lunchbot.Repo.Migrations.CreateOrderItems do
  use Ecto.Migration

  def change do
    create table(:order_items) do
      add :order_id, :integer
      add :item_id, :integer

      timestamps()
    end
  end
end
