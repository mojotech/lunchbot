defmodule Lunchbot.Repo.Migrations.AddMoreFields do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :description, :string
      add :price, :integer
      add :item_image, :string
    end
  end
end
