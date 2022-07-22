defmodule Lunchbot.LunchbotData.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lunchbot.Repo

  schema "orders" do
    field :lunch_order_id, :integer
    # :menu_id
    belongs_to :menu, Lunchbot.LunchbotData.Menu
    field :user_id, :integer
    has_many :order_items, Lunchbot.LunchbotData.OrderItem

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_id, :menu_id, :lunch_order_id])
    |> validate_required([:user_id, :menu_id, :lunch_order_id])
  end

  def get_total(%Lunchbot.LunchbotData.Order{} = order) do
    # total price of an Order the the price of all the items in the order.
    Enum.map(order.order_items, &Lunchbot.LunchbotData.OrderItem.get_total/1)
    |> Enum.sum()
  end
end
