defmodule Lunchbot.Repo.Migrations.RemoveMenuIdField do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      remove :menu_id
    end
  end
end
