defmodule Lunchbot.Repo.Migrations.AlterUserAndOfficeTables do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
    end

    alter table(:offices) do
      add :name, :string
    end
  end
end
