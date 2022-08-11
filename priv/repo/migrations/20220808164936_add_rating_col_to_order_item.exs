defmodule Lunchbot.Repo.Migrations.AddRatingColToOrderItem do
  use Ecto.Migration

  def change do
    alter table(:order_items) do
      add :rating, :integer
    end
  end
end
