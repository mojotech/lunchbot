defmodule Lunchbot.LunchbotData.OrderItemOptions do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_item_options" do
    belongs_to :option, Lunchbot.LunchbotData.Options
    field :order_item_id, :integer

    timestamps()
  end

  @doc false
  def changeset(order_item_options, attrs) do
    order_item_options
    |> cast(attrs, [:order_item_id, :option_id])
    |> validate_required([:order_item_id, :option_id])
  end

  def get_total(%Lunchbot.LunchbotData.OrderItemOptions{} = order_item_option) do
    # the total price of an OrderItemOption is the price the option + included extras
    if order_item_option.option.extras do
      if is_nil(order_item_option.option.extra_price) || is_nil(order_item_option.option.price) do
        nil
      else
        order_item_option.option.extra_price + order_item_option.option.price
      end
    else
      if is_nil(order_item_option.option.price) do
        nil
      else
        order_item_option.option.price
      end
    end
  end
end
