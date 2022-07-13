defmodule Lunchbot.Repo.Migrations.CreateItemExtras do
  use Ecto.Migration

  def change do
    create table(:item_extras) do
      add :item_id, :integer
      add :extra_id, :integer

      timestamps()
    end
  end
end
