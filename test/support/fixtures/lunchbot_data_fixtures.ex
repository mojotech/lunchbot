defmodule Lunchbot.LunchbotDataFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lunchbot.LunchbotData` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "some name",
        email: "some email",
        role: "some role"
      })
      |> Lunchbot.LunchbotData.create_user()

    user
  end

  @doc """
  Generate a office.
  """
  def office_fixture(attrs \\ %{}) do
    {:ok, office} =
      attrs
      |> Enum.into(%{
        name: "some name",
        timezone: "some timezone"
      })
      |> Lunchbot.LunchbotData.create_office()

    office
  end

  @doc """
  Generate a menu.
  """
  def menu_fixture(attrs \\ %{}) do
    {:ok, menu} =
      attrs
      |> Enum.into(%{
        name: "some name",
        office_id: 42
      })
      |> Lunchbot.LunchbotData.create_menu()

    menu
  end

  @doc """
  Generate a office_lunch_order.
  """
  def office_lunch_order_fixture(attrs \\ %{}) do
    {:ok, office_lunch_order} =
      attrs
      |> Enum.into(%{
        day: ~D[2022-07-07],
        office_id: 42
      })
      |> Lunchbot.LunchbotData.create_office_lunch_order()

    office_lunch_order
  end

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        lunch_order_id: 42,
        menu_id: 42,
        user_id: 42
      })
      |> Lunchbot.LunchbotData.create_order()

    order
  end

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        menu_id: 42,
        name: "some name"
      })
      |> Lunchbot.LunchbotData.create_category()

    category
  end

  @doc """
  Generate a order_item.
  """
  def order_item_fixture(attrs \\ %{}) do
    {:ok, order_item} =
      attrs
      |> Enum.into(%{
        item_id: 42,
        order_id: 42
      })
      |> Lunchbot.LunchbotData.create_order_item()

    order_item
  end

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        category_id: 42,
        deleted: true,
        image_url: "some image_url",
        name: "some name"
      })
      |> Lunchbot.LunchbotData.create_item()

    item
  end

  @doc """
  Generate a order_item_extra.
  """
  def order_item_extra_fixture(attrs \\ %{}) do
    {:ok, order_item_extra} =
      attrs
      |> Enum.into(%{
        extra_id: 42,
        order_item_id: 42
      })
      |> Lunchbot.LunchbotData.create_order_item_extra()

    order_item_extra
  end

  @doc """
  Generate a extra.
  """
  def extra_fixture(attrs \\ %{}) do
    {:ok, extra} =
      attrs
      |> Enum.into(%{
        item_id: 42,
        name: "some name"
      })
      |> Lunchbot.LunchbotData.create_extra()

    extra
  end
end
