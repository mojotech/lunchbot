defmodule Lunchbot.LunchbotData.OfficeLunchOrder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_lunch_orders" do
    field :day, :date
    belongs_to :menu, Lunchbot.LunchbotData.Menu
    belongs_to :office, Lunchbot.LunchbotData.Office
    has_many :orders, Lunchbot.LunchbotData.Order, foreign_key: :office_lunch_order_id

    timestamps()
  end

  @doc false
  def changeset(office_lunch_order, attrs) do
    office_lunch_order
    |> cast(attrs, [:day, :office_id, :menu_id])
    |> validate_required([:day, :office_id, :menu_id])
  end
end
