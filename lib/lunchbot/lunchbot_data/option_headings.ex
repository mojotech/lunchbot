defmodule Lunchbot.LunchbotData.OptionHeading do
  use Ecto.Schema
  import Ecto.Changeset

  schema "option_headings" do
    many_to_many :items, Lunchbot.LunchbotData.Item, join_through: "item_option_headings"
    field :name, :string
    field :priority, :integer
    has_many :options, Lunchbot.LunchbotData.Options

    timestamps()
  end

  @doc false
  def changeset(option_headings, attrs) do
    option_headings
    |> cast(attrs, [:name, :priority])
    |> validate_required([:name, :priority])
  end
end
