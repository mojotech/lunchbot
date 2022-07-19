defmodule Lunchbot.Repo.Migrations.CreateOptionHeadings do
  use Ecto.Migration

  def change do
    create table(:option_headings) do
      add :name, :string
      add :priority, :integer

      timestamps()
    end
  end
end
