defmodule Lunchbot.LunchbotData.Options do
  use Ecto.Schema
  import Ecto.Changeset

  schema "options" do
    belongs_to :option_heading, Lunchbot.LunchbotData.OptionHeading
    field :extra_price, :integer
    field :extras, :boolean, default: false
    field :is_required, :boolean, default: false
    field :name, :string
    field :preselected, :boolean, default: false
    field :price, :integer
    has_many :order_item_options, Lunchbot.LunchbotData.OrderItemOptions, foreign_key: :option_id

    timestamps()
  end

  @doc false
  def changeset(options, attrs) do
    options
    |> cast(attrs, [
      :name,
      :option_heading_id,
      :extras,
      :price,
      :extra_price,
      :is_required,
      :preselected
    ])
    |> validate_required([
      :name,
      :option_heading_id,
      :extras,
      :price,
      :extra_price,
      :is_required,
      :preselected
    ])
  end
end
