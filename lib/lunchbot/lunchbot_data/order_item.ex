defmodule Lunchbot.LunchbotData.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_items" do
    field :item_id, :integer
    field :order_id, :integer

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:order_id, :item_id])
    |> validate_required([:order_id, :item_id])
  end
end
