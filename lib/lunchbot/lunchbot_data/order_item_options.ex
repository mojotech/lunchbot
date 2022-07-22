defmodule Lunchbot.LunchbotData.OrderItemOptions do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_item_options" do
    # option_id
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
end
