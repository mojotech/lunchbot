defmodule Lunchbot.LunchbotData.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :category_id, :integer
    field :deleted, :boolean, default: false
    field :description, :string
    field :image_url, :string
    field :item_image, :string
    field :name, :string
    field :price, :integer

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :description, :price, :category_id, :image_url, :item_image, :deleted])
    |> validate_required([:name, :price, :category_id])
  end
end
