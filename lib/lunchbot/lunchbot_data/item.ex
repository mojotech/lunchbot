defmodule Lunchbot.LunchbotData.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :category_id, :integer
    field :deleted, :boolean, default: false
    field :image_url, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :category_id, :image_url, :deleted])
    |> validate_required([:name, :category_id, :image_url, :deleted])
  end
end
