defmodule Lunchbot.LunchbotData.Extra do
  use Ecto.Schema
  import Ecto.Changeset

  schema "extras" do
    field :item_id, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(extra, attrs) do
    extra
    |> cast(attrs, [:name, :item_id])
    |> validate_required([:name, :item_id])
  end
end
