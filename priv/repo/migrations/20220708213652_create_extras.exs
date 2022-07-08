defmodule Lunchbot.Repo.Migrations.CreateExtras do
  use Ecto.Migration

  def change do
    create table(:extras) do
      add :name, :string
      add :item_id, :integer

      timestamps()
    end
  end
end
