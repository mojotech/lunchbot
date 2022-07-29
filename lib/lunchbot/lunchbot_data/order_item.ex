defmodule Lunchbot.LunchbotData.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_items" do
    belongs_to :item, Lunchbot.LunchbotData.Item
    field :order_id, :integer
    has_many :order_item_options, Lunchbot.LunchbotData.OrderItemOptions

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:order_id, :item_id])
    |> validate_required([:order_id, :item_id])
  end

  def get_total(%Lunchbot.LunchbotData.OrderItem{} = order_item) do
    total_options_price =
      Enum.map(order_item.order_item_options, &Lunchbot.LunchbotData.OrderItemOptions.get_total/1)
      |> Enum.sum()

    # the total price of an OrderItem is the price of it's Options + the Item itself
    total_options_price + order_item.item.price
  end
end
