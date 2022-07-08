defmodule Lunchbot.LunchbotData.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :lunch_order_id, :integer
    field :menu_id, :integer
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_id, :menu_id, :lunch_order_id])
    |> validate_required([:user_id, :menu_id, :lunch_order_id])
  end
end
