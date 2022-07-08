defmodule Lunchbot.LunchbotData.Menu do
  use Ecto.Schema
  import Ecto.Changeset

  schema "menus" do
    field :name, :string
    field :office_id, :integer

    timestamps()
  end

  @doc false
  def changeset(menu, attrs) do
    menu
    |> cast(attrs, [:name, :office_id])
    |> validate_required([:name, :office_id])
  end
end
