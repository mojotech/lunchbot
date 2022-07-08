defmodule Lunchbot.Repo.Migrations.CreateOffices do
  use Ecto.Migration

  def change do
    create table(:offices) do
      add :timezone, :string

      timestamps()
    end
  end
end
