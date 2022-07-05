defmodule Lunchbot.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table("users") do
      add :avatar, :string
      add :email, :string
      add :name, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
