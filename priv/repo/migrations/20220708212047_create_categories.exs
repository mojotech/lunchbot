defmodule Lunchbot.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :menu_id, :integer

      timestamps()
    end
  end
end
