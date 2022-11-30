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
        name: "#{Faker.Person.first_name()} #{Faker.Person.last_name()}",
        email: Faker.Internet.email(),
        password: "some_password",
        role: "admin",
        confirmed_at: ~N[2001-01-01 23:00:07]
      })
      |> Lunchbot.Accounts.create_user()

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
    office = office_fixture()

    {:ok, menu} =
      attrs
      |> Enum.into(%{
        name: "some name",
        office_id: office.id
      })
      |> Lunchbot.LunchbotData.create_menu()

    menu
  end

  @doc """
  Generate a office_lunch_order.
  """
  def office_lunch_order_fixture(attrs \\ %{}) do
    office = office_fixture()
    menu = menu_fixture()

    {:ok, office_lunch_order} =
      attrs
      |> Enum.into(%{
        day: ~D[2022-07-07],
        office_id: office.id,
        menu_id: menu.id
      })
      |> Lunchbot.LunchbotData.create_office_lunch_order()

    office_lunch_order
  end

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    # create user
    # create office lunch order
    # create menu
    # pass params to order_fixture
    user = user_fixture()
    office = office_fixture()
    menu = menu_fixture(%{office_id: office.id})

    office_lunch_order = office_lunch_order_fixture(%{office_id: office.id, menu_id: menu.id})

    fixtures = %{
      office_lunch_order_id: office_lunch_order.id,
      menu_id: menu.id,
      user_id: user.id
    }

    {:ok, order} =
      Enum.into(fixtures, attrs)
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
        name: "some name"
      })
      |> Lunchbot.LunchbotData.create_category()

    category
  end

  @doc """
  Generate a order_item.
  """
  def order_item_fixture(attrs \\ %{}) do
    # create item
    # create order
    item = item_fixture()
    order = order_fixture()

    {:ok, order_item} =
      attrs
      |> Enum.into(%{
        item_id: item.id,
        order_id: order.id
      })
      |> Lunchbot.LunchbotData.create_order_item()

    order_item
  end

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    # create category
    category = category_fixture()

    {:ok, item} =
      attrs
      |> Enum.into(%{
        category_id: category.id,
        deleted: true,
        description: "some description",
        image_url: "some image_url",
        name: "some name",
        price: 10
      })
      |> Lunchbot.LunchbotData.create_item()

    item
  end

  @doc """
  Generate a item_option_headings.
  """
  def item_option_headings_fixture(attrs \\ %{}) do
    {:ok, item_option_headings} =
      attrs
      |> Enum.into(%{
        item_id: 42,
        option_heading_id: 42
      })
      |> Lunchbot.LunchbotData.create_item_option_headings()

    item_option_headings
  end

  @doc """
  Generate a option_headings.
  """
  def option_headings_fixture(attrs \\ %{}) do
    {:ok, option_headings} =
      attrs
      |> Enum.into(%{
        name: "some name",
        priority: 42
      })
      |> Lunchbot.LunchbotData.create_option_headings()

    option_headings
  end

  @doc """
  Generate a order_item_options.
  """
  def order_item_options_fixture(attrs \\ %{}) do
    option = options_fixture()
    order_item = order_item_fixture()

    {:ok, order_item_options} =
      attrs
      |> Enum.into(%{
        option_id: option.id,
        order_item_id: order_item.id
      })
      |> Lunchbot.LunchbotData.create_order_item_options()

    order_item_options
  end

  @doc """
  Generate a options.
  """
  def options_fixture(attrs \\ %{}) do
    # create option_heading
    option_heading = option_headings_fixture()

    {:ok, options} =
      attrs
      |> Enum.into(%{
        extra_price: 42,
        extras: true,
        is_required: true,
        name: "some name",
        option_heading_id: option_heading.id,
        preselected: true,
        price: 42
      })
      |> Lunchbot.LunchbotData.create_options()

    options
  end

  @doc """
  Generate a menu_categories.
  """
  def menu_categories_fixture(attrs \\ %{}) do
    {:ok, menu_categories} =
      attrs
      |> Enum.into(%{
        category_id: 42,
        menu_id: 42
      })
      |> Lunchbot.LunchbotData.create_menu_categories()

    menu_categories
  end
end
