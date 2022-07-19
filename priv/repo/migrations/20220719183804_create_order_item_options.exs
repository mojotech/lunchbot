defmodule Lunchbot.Repo.Migrations.CreateOrderItemOptions do
  use Ecto.Migration

  def change do
    create table(:order_item_options) do
      add :order_item_id, :integer
      add :option_id, :integer

      timestamps()
    end
  end
end
