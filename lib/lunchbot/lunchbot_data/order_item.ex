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
    # the total price of an OrderItem is the price of it's Options + the Item itself
    list_total_options_prices =
      Enum.map(order_item.order_item_options, &Lunchbot.LunchbotData.OrderItemOptions.get_total/1)

    if Enum.member?(list_total_options_prices, nil) ||
         is_nil(order_item.item.price) do
      nil
    else
      Enum.sum(list_total_options_prices) + order_item.item.price
    end
  end
end
