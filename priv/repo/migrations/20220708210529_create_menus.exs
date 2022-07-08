defmodule Lunchbot.Repo.Migrations.CreateMenus do
  use Ecto.Migration

  def change do
    create table(:menus) do
      add :name, :string
      add :office_id, :integer

      timestamps()
    end
  end
end
