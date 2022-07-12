defmodule Lunchbot.Repo.Migrations.AlterUsersAuthTables do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""
    execute "ALTER TABLE users DROP COLUMN IF EXISTS hashed_password"
    execute "ALTER TABLE users DROP COLUMN IF EXISTS confirmed_at"
    execute "DROP INDEX IF EXISTS users_email_index"

    alter table(:users) do
      modify :email, :citext, null: false
      add :hashed_password, :string
      add :confirmed_at, :naive_datetime
    end

    create unique_index(:users, [:email])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end

  def down do
    drop table(:users_tokens)
    drop index(:users, [:email], name: :users_email_index)

    alter table(:users) do
      remove :confirmed_at
      remove :hashed_password
      modify :email, :string
    end
  end
end
