defmodule Lunchbot.Repo.Migrations.CreateOptions do
  use Ecto.Migration

  def change do
    create table(:options) do
      add :name, :string
      add :option_heading_id, :integer
      add :extras, :boolean, default: false, null: false
      add :price, :integer
      add :extra_price, :integer
      add :is_required, :boolean, default: false, null: false
      add :preselected, :boolean, default: false, null: false

      timestamps()
    end
  end
end
