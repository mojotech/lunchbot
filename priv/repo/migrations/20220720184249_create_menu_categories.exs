defmodule Lunchbot.Repo.Migrations.CreateMenuCategories do
  use Ecto.Migration

  def change do
    create table(:menu_categories) do
      add :category_id, :integer
      add :menu_id, :integer

      timestamps()
    end
  end
end
