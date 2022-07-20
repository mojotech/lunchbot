defmodule Lunchbot.LunchbotData.OptionHeadings do
  use Ecto.Schema
  import Ecto.Changeset

  schema "option_headings" do
    field :name, :string
    field :priority, :integer

    timestamps()
  end

  @doc false
  def changeset(option_headings, attrs) do
    option_headings
    |> cast(attrs, [:name, :priority])
    |> validate_required([:name, :priority])
  end
end
