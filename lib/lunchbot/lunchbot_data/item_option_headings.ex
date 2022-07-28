defmodule Lunchbot.LunchbotData.ItemOptionHeadings do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item_option_headings" do
    belongs_to :item, Lunchbot.LunchbotData.Item
    belongs_to :option_heading, Lunchbot.LunchbotData.OptionHeading

    timestamps()
  end

  @doc false
  def changeset(item_option_headings, attrs) do
    item_option_headings
    |> cast(attrs, [:item_id, :option_heading_id])
    |> validate_required([:item_id, :option_heading_id])
  end
end
