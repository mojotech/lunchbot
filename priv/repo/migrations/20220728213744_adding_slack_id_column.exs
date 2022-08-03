defmodule Lunchbot.Repo.Migrations.AddingSlackIdColumn do
  use Ecto.Migration

  def change do
    alter table(:offices) do
      add :slack_channel_name, :string
    end
  end
end
