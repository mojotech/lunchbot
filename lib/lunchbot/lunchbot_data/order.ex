defmodule Lunchbot.LunchbotData.Order do
  use Ecto.Schema
  import Ecto.Changeset

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
end
