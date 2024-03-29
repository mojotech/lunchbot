defmodule Lunchbot.LunchbotData.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_items" do
    belongs_to :item, Lunchbot.LunchbotData.Item
    has_many :order_item_options, Lunchbot.LunchbotData.OrderItemOptions
    belongs_to :order, Lunchbot.LunchbotData.Order

    many_to_many :options, Lunchbot.LunchbotData.Options,
      join_through: "order_item_options",
      join_keys: [order_item_id: :id, option_id: :id]

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:order_id, :item_id])
    |> validate_required([:order_id, :item_id])
  end

  # "OrderItem"
  @topic inspect(__MODULE__)

  # Subscribe to all order_items
  def subscribe do
    Phoenix.PubSub.subscribe(Lunchbot.PubSub, @topic)
  end

  # Subscribe to a /specific/ order_item
  def subscribe(order_item_id) do
    Phoenix.PubSub.subscribe(Lunchbot.PubSub, @topic <> "#{order_item_id}")
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

  # Broadcasts the data or error along with the event name to all subscribers.
  # Returns its first argument unchanged, so we can drop it into CRUD pipelines without changing their output.
  def notify_subscribers({:ok, result}, event) do
    Phoenix.PubSub.broadcast(Lunchbot.PubSub, @topic, {__MODULE__, event, result})

    Phoenix.PubSub.broadcast(
      Lunchbot.PubSub,
      @topic <> "#{result.id}",
      {__MODULE__, event, result}
    )

    {:ok, result}
  end

  def notify_subscribers({:error, reason}, _) do
    {:error, reason}
  end
end
