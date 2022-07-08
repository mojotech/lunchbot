defmodule Lunchbot.LunchbotData.OrderItemExtra do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_item_extras" do
    field :extra_id, :integer
    field :order_item_id, :integer

    timestamps()
  end

  @doc false
  def changeset(order_item_extra, attrs) do
    order_item_extra
    |> cast(attrs, [:order_item_id, :extra_id])
    |> validate_required([:order_item_id, :extra_id])
  end
end
