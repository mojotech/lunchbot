defmodule Lunchbot.Repo.Migrations.AddMenuIdToOfficeLunchOrder do
  use Ecto.Migration

  def change do
    alter table(:office_lunch_orders) do
      add :menu_id, :integer
    end
  end
end
