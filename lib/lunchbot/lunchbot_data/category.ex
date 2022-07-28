defmodule Lunchbot.LunchbotData.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    many_to_many :menus, Lunchbot.LunchbotData.Menu, join_through: "menu_categories"
    field :name, :string
    has_many :items, Lunchbot.LunchbotData.Item

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
