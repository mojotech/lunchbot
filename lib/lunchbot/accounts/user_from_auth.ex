defmodule UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  """
  require Logger
  require Jason

  alias Ueberauth.Auth

  def find_or_create(%Auth{} = auth) do
    {:ok, basic_info(auth)}
  end

  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

  defp avatar_from_auth(%{info: %{image: image}}), do: image

  defp avatar_from_auth(auth) do
    Logger.warn(auth.provider <> " needs to find an avatar URL!")
    Logger.debug(Jason.encode!(auth))
    nil
  end

  defp basic_info(auth) do
    %{
      id: auth.uid,
      name: name_from_auth(auth),
      avatar: avatar_from_auth(auth),
      email: email_from_auth(auth)
    }
  end

  defp email_from_auth(%{info: %{email: email}}), do: email

  defp email_from_auth(auth) do
    Logger.warn(auth.provider <> " needs to find an avatar URL!")
    Logger.debug(Jason.encode!(auth))
    nil
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      cond do
        length(name) == 0 -> auth.info.nickname
        true -> Enum.join(name, " ")
      end
    end
  end
end
