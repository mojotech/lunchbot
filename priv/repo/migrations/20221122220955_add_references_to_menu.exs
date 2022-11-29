defmodule Lunchbot.Repo.Migrations.AddReferencesToMenu do
  use Ecto.Migration

  def change do
    alter table(:menus) do
      modify :office_id, references(:offices, on_delete: :delete_all)
    end
  end
end
