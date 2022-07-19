defmodule Lunchbot.LunchbotData.ItemOptionHeadings do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item_option_headings" do
    field :item_id, :integer
    field :option_heading_id, :integer

    timestamps()
  end

  @doc false
  def changeset(item_option_headings, attrs) do
    item_option_headings
    |> cast(attrs, [:item_id, :option_heading_id])
    |> validate_required([:item_id, :option_heading_id])
  end
end
