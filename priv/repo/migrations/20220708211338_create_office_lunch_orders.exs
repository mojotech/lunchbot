defmodule Lunchbot.Repo.Migrations.CreateOfficeLunchOrders do
  use Ecto.Migration

  def change do
    create table(:office_lunch_orders) do
      add :day, :date
      add :office_id, :integer

      timestamps()
    end
  end
end
