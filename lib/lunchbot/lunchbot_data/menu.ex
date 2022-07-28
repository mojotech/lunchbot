defmodule Lunchbot.LunchbotData.Menu do
  use Ecto.Schema
  import Ecto.Changeset

  schema "menus" do
    field :name, :string
    field :office_id, :integer
    many_to_many :categories, Lunchbot.LunchbotData.Category, join_through: "menu_categories"

    timestamps()
  end

  @doc false
  def changeset(menu, attrs) do
    menu
    |> cast(attrs, [:name, :office_id])
    |> validate_required([:name, :office_id])
  end
end
