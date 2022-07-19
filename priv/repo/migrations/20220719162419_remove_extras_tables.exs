defmodule Lunchbot.Repo.Migrations.RemoveExtrasTables do
  use Ecto.Migration

  def up do
    drop table(:order_item_extras)
    drop table(:extras)
    drop table(:item_extras)
  end

  def down do
    create table(:order_item_extras) do
      add :order_item_id, :integer
      add :extra_id, :integer

      timestamps()
    end

    create table(:extras) do
      add :name, :string
      add :item_id, :integer

      timestamps()
    end

    create table(:item_extras) do
      add :item_id, :integer
      add :extra_id, :integer

      timestamps()
    end
  end
end
