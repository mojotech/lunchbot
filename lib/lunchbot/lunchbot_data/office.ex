defmodule Lunchbot.LunchbotData.Office do
  use Ecto.Schema
  import Ecto.Changeset

  schema "offices" do
    field :timezone, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(office, attrs) do
    office
    |> cast(attrs, [:timezone, :name])
    |> validate_required([:timezone, :name])
  end
end
