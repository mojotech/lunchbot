defmodule Lunchbot.LunchbotData.Office do
  use Ecto.Schema
  import Ecto.Changeset

  schema "offices" do
    field :timezone, :string

    timestamps()
  end

  @doc false
  def changeset(office, attrs) do
    office
    |> cast(attrs, [:timezone])
    |> validate_required([:timezone])
  end
end
