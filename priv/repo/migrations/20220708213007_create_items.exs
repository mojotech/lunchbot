defmodule Lunchbot.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :category_id, :integer
      add :image_url, :string
      add :deleted, :boolean, default: false, null: false

      timestamps()
    end
  end
end
