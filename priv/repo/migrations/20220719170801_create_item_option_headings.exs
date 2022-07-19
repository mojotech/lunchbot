defmodule Lunchbot.Repo.Migrations.CreateItemOptionHeadings do
  use Ecto.Migration

  def change do
    create table(:item_option_headings) do
      add :item_id, :integer
      add :option_heading_id, :integer

      timestamps()
    end
  end
end
