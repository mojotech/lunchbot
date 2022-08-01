defmodule Lunchbot.LunchbotData.OfficeLunchOrder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "office_lunch_orders" do
    field :day, :date
    field :office_id, :integer
    field :menu_id, :integer

    timestamps()
  end

  @doc false
  def changeset(office_lunch_order, attrs) do
    office_lunch_order
    |> cast(attrs, [:day, :office_id, :menu_id])
    |> validate_required([:day, :office_id, :menu_id])
  end
end
