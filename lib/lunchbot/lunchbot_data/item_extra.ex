defmodule Lunchbot.LunchbotData.ItemExtra do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item_extras" do
    field :extra_id, :integer
    field :item_id, :integer

    timestamps()
  end

  @doc false
  def changeset(item_extra, attrs) do
    item_extra
    |> cast(attrs, [:item_id, :extra_id])
    |> validate_required([:item_id, :extra_id])
  end
end
