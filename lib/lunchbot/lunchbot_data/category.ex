defmodule Lunchbot.LunchbotData.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :menu_id, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :menu_id])
    |> validate_required([:name, :menu_id])
  end
end
