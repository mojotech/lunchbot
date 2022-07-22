defmodule Lunchbot.LunchbotData.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    belongs_to :category, Lunchbot.LunchbotData.Category
    field :deleted, :boolean, default: false
    field :description, :string
    field :image_url, :string
    field :item_image, :string
    field :name, :string
    field :price, :integer
    has_many :order_items, Lunchbot.LunchbotData.OrderItem

    many_to_many :option_headings, Lunchbot.LunchbotData.OptionHeading,
      join_through: "item_option_headings"

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :description, :price, :category_id, :image_url, :item_image, :deleted])
    |> validate_required([:name, :price, :category_id])
  end
end
