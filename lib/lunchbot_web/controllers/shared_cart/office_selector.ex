defmodule LunchbotWeb.SharedCart.OfficeSelector do
  defstruct [:office_id]
  @types %{office_id: :integer}

  import Ecto.Changeset

  def changeset(%__MODULE__{} = office, attrs) do
    {office, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:office_id])
  end
end
