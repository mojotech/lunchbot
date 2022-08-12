defmodule LunchbotWeb.SharedCart.OfficeSelectorInterfaceContext do
  alias LunchbotWeb.SharedCart.OfficeSelector

  def change_office(%OfficeSelector{} = user, attrs \\ %{}) do
    OfficeSelector.changeset(user, attrs)
  end
end
