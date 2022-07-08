defmodule Lunchbot.Repo.Migrations.CreateOrderItemExtras do
  use Ecto.Migration

  def change do
    create table(:order_item_extras) do
      add :order_item_id, :integer
      add :extra_id, :integer

      timestamps()
    end
  end
end
