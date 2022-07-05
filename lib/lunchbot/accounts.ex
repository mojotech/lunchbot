defmodule Lunchbot.Accounts do
  @moduledoc """
  The Accounts context
  """

  import Ecto.Query, warn: false
  alias Lunchbot.Repo
  alias Lunchbot.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_or_create_user(user = %{email: email}) do
    case Repo.get_by(User, %{email: email}) do
      user = %User{} -> {:ok, user}
      nil -> create_user(user)
    end
  end

  def get_user_from_id(id) when is_nil(id), do: nil

  def get_user_from_id(id) do
    case Repo.get(User, id) do
      nil -> nil
      user -> user
    end
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
end
