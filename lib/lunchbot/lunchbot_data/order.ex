defmodule Lunchbot.LunchbotData.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lunchbot.Repo

  schema "orders" do
    field :lunch_order_id, :integer
    belongs_to :menu, Lunchbot.LunchbotData.Menu
    belongs_to :user, Lunchbot.Accounts.User
    has_many :order_items, Lunchbot.LunchbotData.OrderItem
    many_to_many :items, Lunchbot.LunchbotData.Item, join_through: "order_items"

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
    list_order_totals = Enum.map(order.order_items, &Lunchbot.LunchbotData.OrderItem.get_total/1)

    # check for nil values, return nil if found
    if Enum.member?(list_order_totals, nil) do
      nil
    else
      list_order_totals |> Enum.sum()
    end
  end
end
