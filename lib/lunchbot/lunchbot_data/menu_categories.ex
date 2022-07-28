defmodule Lunchbot.LunchbotData.MenuCategories do
  use Ecto.Schema
  import Ecto.Changeset

  schema "menu_categories" do
    belongs_to :category, Lunchbot.LunchbotData.Category
    belongs_to :menu, Lunchbot.LunchbotData.Menu

    timestamps()
  end

  @doc false
  def changeset(menu_categories, attrs) do
    menu_categories
    |> cast(attrs, [:category_id, :menu_id])
    |> validate_required([:category_id, :menu_id])
  end
end
