defmodule Lunchbot.LunchbotData do
  @moduledoc """
  The LunchbotData context.
  """

  import Ecto.Query, warn: false
  alias Lunchbot.Repo
  import Torch.Helpers, only: [sort: 1, paginate: 4, strip_unset_booleans: 3]
  import Filtrex.Type.Config

  alias Lunchbot.LunchbotData.Office

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of offices using filtrex
  filters.

  ## Examples

      iex> paginate_offices(%{})
      %{offices: [%Office{}], ...}

  """
  @spec paginate_offices(map) :: {:ok, map} | {:error, any}
  def paginate_offices(params \\ %{}) do
    params =
      params
      |> strip_unset_booleans("office", [])
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:offices), params["office"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_offices(filter, params) do
      {:ok,
       %{
         offices: page.entries,
         page_number: page.page_number,
         page_size: page.page_size,
         total_pages: page.total_pages,
         total_entries: page.total_entries,
         distance: @pagination_distance,
         sort_field: sort_field,
         sort_direction: sort_direction
       }}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  defp do_paginate_offices(filter, params) do
    Office
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of offices.

  ## Examples

      iex> list_offices()
      [%Office{}, ...]

  """
  def list_offices do
    Repo.all(Office)
  end

  @doc """
  Gets a single office.

  Raises `Ecto.NoResultsError` if the Office does not exist.

  ## Examples

      iex> get_office!(123)
      %Office{}

      iex> get_office!(456)
      ** (Ecto.NoResultsError)

  """
  def get_office!(id), do: Repo.get!(Office, id)

  @doc """
  Creates a office.

  ## Examples

      iex> create_office(%{field: value})
      {:ok, %Office{}}

      iex> create_office(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_office(attrs \\ %{}) do
    %Office{}
    |> Office.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a office.

  ## Examples

      iex> update_office(office, %{field: new_value})
      {:ok, %Office{}}

      iex> update_office(office, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_office(%Office{} = office, attrs) do
    office
    |> Office.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Office.

  ## Examples

      iex> delete_office(office)
      {:ok, %Office{}}

      iex> delete_office(office)
      {:error, %Ecto.Changeset{}}

  """
  def delete_office(%Office{} = office) do
    Repo.delete(office)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking office changes.

  ## Examples

      iex> change_office(office)
      %Ecto.Changeset{source: %Office{}}

  """
  def change_office(%Office{} = office, attrs \\ %{}) do
    Office.changeset(office, attrs)
  end

  import Torch.Helpers, only: [sort: 1, paginate: 4, strip_unset_booleans: 3]
  import Filtrex.Type.Config

  alias Lunchbot.LunchbotData.Menu

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of menus using filtrex
  filters.

  ## Examples

      iex> paginate_menus(%{})
      %{menus: [%Menu{}], ...}

  """
  @spec paginate_menus(map) :: {:ok, map} | {:error, any}
  def paginate_menus(params \\ %{}) do
    params =
      params
      |> strip_unset_booleans("menu", [])
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:menus), params["menu"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_menus(filter, params) do
      {:ok,
       %{
         menus: page.entries,
         page_number: page.page_number,
         page_size: page.page_size,
         total_pages: page.total_pages,
         total_entries: page.total_entries,
         distance: @pagination_distance,
         sort_field: sort_field,
         sort_direction: sort_direction
       }}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  defp do_paginate_menus(filter, params) do
    Menu
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of menus.

  ## Examples

      iex> list_menus()
      [%Menu{}, ...]

  """
  def list_menus do
    Repo.all(Menu)
  end

  @doc """
  Gets a single menu.

  Raises `Ecto.NoResultsError` if the Menu does not exist.

  ## Examples

      iex> get_menu!(123)
      %Menu{}

      iex> get_menu!(456)
      ** (Ecto.NoResultsError)

  """
  def get_menu!(id), do: Repo.get!(Menu, id)

  @doc """
  Creates a menu.

  ## Examples

      iex> create_menu(%{field: value})
      {:ok, %Menu{}}

      iex> create_menu(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_menu(attrs \\ %{}) do
    %Menu{}
    |> Menu.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a menu.

  ## Examples

      iex> update_menu(menu, %{field: new_value})
      {:ok, %Menu{}}

      iex> update_menu(menu, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_menu(%Menu{} = menu, attrs) do
    menu
    |> Menu.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Menu.

  ## Examples

      iex> delete_menu(menu)
      {:ok, %Menu{}}

      iex> delete_menu(menu)
      {:error, %Ecto.Changeset{}}

  """
  def delete_menu(%Menu{} = menu) do
    Repo.delete(menu)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking menu changes.

  ## Examples

      iex> change_menu(menu)
      %Ecto.Changeset{source: %Menu{}}

  """
  def change_menu(%Menu{} = menu, attrs \\ %{}) do
    Menu.changeset(menu, attrs)
  end

  import Torch.Helpers, only: [sort: 1, paginate: 4, strip_unset_booleans: 3]
  import Filtrex.Type.Config

  alias Lunchbot.LunchbotData.OfficeLunchOrder

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of office_lunch_orders using filtrex
  filters.

  ## Examples

      iex> paginate_office_lunch_orders(%{})
      %{office_lunch_orders: [%OfficeLunchOrder{}], ...}

  """
  @spec paginate_office_lunch_orders(map) :: {:ok, map} | {:error, any}
  def paginate_office_lunch_orders(params \\ %{}) do
    params =
      params
      |> strip_unset_booleans("office_lunch_order", [])
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <-
           Filtrex.parse_params(
             filter_config(:office_lunch_orders),
             params["office_lunch_order"] || %{}
           ),
         %Scrivener.Page{} = page <- do_paginate_office_lunch_orders(filter, params) do
      {:ok,
       %{
         office_lunch_orders: page.entries,
         page_number: page.page_number,
         page_size: page.page_size,
         total_pages: page.total_pages,
         total_entries: page.total_entries,
         distance: @pagination_distance,
         sort_field: sort_field,
         sort_direction: sort_direction
       }}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  defp do_paginate_office_lunch_orders(filter, params) do
    OfficeLunchOrder
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of office_lunch_orders.

  ## Examples

      iex> list_office_lunch_orders()
      [%OfficeLunchOrder{}, ...]

  """
  def list_office_lunch_orders do
    Repo.all(OfficeLunchOrder)
  end

  @doc """
  Gets a single office_lunch_order.

  Raises `Ecto.NoResultsError` if the Office lunch order does not exist.

  ## Examples

      iex> get_office_lunch_order!(123)
      %OfficeLunchOrder{}

      iex> get_office_lunch_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_office_lunch_order!(id), do: Repo.get!(OfficeLunchOrder, id)

  @doc """
  Creates a office_lunch_order.

  ## Examples

      iex> create_office_lunch_order(%{field: value})
      {:ok, %OfficeLunchOrder{}}

      iex> create_office_lunch_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_office_lunch_order(attrs \\ %{}) do
    %OfficeLunchOrder{}
    |> OfficeLunchOrder.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a office_lunch_order.

  ## Examples

      iex> update_office_lunch_order(office_lunch_order, %{field: new_value})
      {:ok, %OfficeLunchOrder{}}

      iex> update_office_lunch_order(office_lunch_order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_office_lunch_order(%OfficeLunchOrder{} = office_lunch_order, attrs) do
    office_lunch_order
    |> OfficeLunchOrder.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a OfficeLunchOrder.

  ## Examples

      iex> delete_office_lunch_order(office_lunch_order)
      {:ok, %OfficeLunchOrder{}}

      iex> delete_office_lunch_order(office_lunch_order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_office_lunch_order(%OfficeLunchOrder{} = office_lunch_order) do
    Repo.delete(office_lunch_order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking office_lunch_order changes.

  ## Examples

      iex> change_office_lunch_order(office_lunch_order)
      %Ecto.Changeset{source: %OfficeLunchOrder{}}

  """
  def change_office_lunch_order(%OfficeLunchOrder{} = office_lunch_order, attrs \\ %{}) do
    OfficeLunchOrder.changeset(office_lunch_order, attrs)
  end

  import Torch.Helpers, only: [sort: 1, paginate: 4, strip_unset_booleans: 3]
  import Filtrex.Type.Config

  alias Lunchbot.LunchbotData.Order

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of orders using filtrex
  filters.

  ## Examples

      iex> paginate_orders(%{})
      %{orders: [%Order{}], ...}

  """
  @spec paginate_orders(map) :: {:ok, map} | {:error, any}
  def paginate_orders(params \\ %{}) do
    params =
      params
      |> strip_unset_booleans("order", [])
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:orders), params["order"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_orders(filter, params) do
      {:ok,
       %{
         orders: page.entries,
         page_number: page.page_number,
         page_size: page.page_size,
         total_pages: page.total_pages,
         total_entries: page.total_entries,
         distance: @pagination_distance,
         sort_field: sort_field,
         sort_direction: sort_direction
       }}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  defp do_paginate_orders(filter, params) do
    Order
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{source: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  import Torch.Helpers, only: [sort: 1, paginate: 4, strip_unset_booleans: 3]
  import Filtrex.Type.Config

  alias Lunchbot.LunchbotData.Category

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of categories using filtrex
  filters.

  ## Examples

      iex> paginate_categories(%{})
      %{categories: [%Category{}], ...}

  """
  @spec paginate_categories(map) :: {:ok, map} | {:error, any}
  def paginate_categories(params \\ %{}) do
    params =
      params
      |> strip_unset_booleans("category", [])
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <-
           Filtrex.parse_params(filter_config(:categories), params["category"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_categories(filter, params) do
      {:ok,
       %{
         categories: page.entries,
         page_number: page.page_number,
         page_size: page.page_size,
         total_pages: page.total_pages,
         total_entries: page.total_entries,
         distance: @pagination_distance,
         sort_field: sort_field,
         sort_direction: sort_direction
       }}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  defp do_paginate_categories(filter, params) do
    Category
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  import Torch.Helpers, only: [sort: 1, paginate: 4, strip_unset_booleans: 3]
  import Filtrex.Type.Config

  alias Lunchbot.LunchbotData.OrderItem

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of order_items using filtrex
  filters.

  ## Examples

      iex> paginate_order_items(%{})
      %{order_items: [%OrderItem{}], ...}

  """
  @spec paginate_order_items(map) :: {:ok, map} | {:error, any}
  def paginate_order_items(params \\ %{}) do
    params =
      params
      |> strip_unset_booleans("order_item", [])
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <-
           Filtrex.parse_params(filter_config(:order_items), params["order_item"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_order_items(filter, params) do
      {:ok,
       %{
         order_items: page.entries,
         page_number: page.page_number,
         page_size: page.page_size,
         total_pages: page.total_pages,
         total_entries: page.total_entries,
         distance: @pagination_distance,
         sort_field: sort_field,
         sort_direction: sort_direction
       }}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  defp do_paginate_order_items(filter, params) do
    OrderItem
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of order_items.

  ## Examples

      iex> list_order_items()
      [%OrderItem{}, ...]

  """
  def list_order_items do
    Repo.all(OrderItem)
  end

  @doc """
  Gets a single order_item.

  Raises `Ecto.NoResultsError` if the Order item does not exist.

  ## Examples

      iex> get_order_item!(123)
      %OrderItem{}

      iex> get_order_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_item!(id), do: Repo.get!(OrderItem, id)

  @doc """
  Creates a order_item.

  ## Examples

      iex> create_order_item(%{field: value})
      {:ok, %OrderItem{}}

      iex> create_order_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_item(attrs \\ %{}) do
    %OrderItem{}
    |> OrderItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order_item.

  ## Examples

      iex> update_order_item(order_item, %{field: new_value})
      {:ok, %OrderItem{}}

      iex> update_order_item(order_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_item(%OrderItem{} = order_item, attrs) do
    order_item
    |> OrderItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a OrderItem.

  ## Examples

      iex> delete_order_item(order_item)
      {:ok, %OrderItem{}}

      iex> delete_order_item(order_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_item(%OrderItem{} = order_item) do
    Repo.delete(order_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_item changes.

  ## Examples

      iex> change_order_item(order_item)
      %Ecto.Changeset{source: %OrderItem{}}

  """
  def change_order_item(%OrderItem{} = order_item, attrs \\ %{}) do
    OrderItem.changeset(order_item, attrs)
  end

  import Torch.Helpers, only: [sort: 1, paginate: 4, strip_unset_booleans: 3]
  import Filtrex.Type.Config

  alias Lunchbot.LunchbotData.Item

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of items using filtrex
  filters.

  ## Examples

      iex> paginate_items(%{})
      %{items: [%Item{}], ...}

  """
  @spec paginate_items(map) :: {:ok, map} | {:error, any}
  def paginate_items(params \\ %{}) do
    params =
      params
      |> strip_unset_booleans("item", [:deleted])
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:items), params["item"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_items(filter, params) do
      {:ok,
       %{
         items: page.entries,
         page_number: page.page_number,
         page_size: page.page_size,
         total_pages: page.total_pages,
         total_entries: page.total_entries,
         distance: @pagination_distance,
         sort_field: sort_field,
         sort_direction: sort_direction
       }}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  defp do_paginate_items(filter, params) do
    Item
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Repo.all(Item)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{source: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end

  import Torch.Helpers, only: [sort: 1, paginate: 4, strip_unset_booleans: 3]
  import Filtrex.Type.Config

  alias Lunchbot.LunchbotData.OrderItemExtra

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of order_item_extras using filtrex
  filters.

  ## Examples

      iex> paginate_order_item_extras(%{})
      %{order_item_extras: [%OrderItemExtra{}], ...}

  """
  @spec paginate_order_item_extras(map) :: {:ok, map} | {:error, any}
  def paginate_order_item_extras(params \\ %{}) do
    params =
      params
      |> strip_unset_booleans("order_item_extra", [])
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <-
           Filtrex.parse_params(
             filter_config(:order_item_extras),
             params["order_item_extra"] || %{}
           ),
         %Scrivener.Page{} = page <- do_paginate_order_item_extras(filter, params) do
      {:ok,
       %{
         order_item_extras: page.entries,
         page_number: page.page_number,
         page_size: page.page_size,
         total_pages: page.total_pages,
         total_entries: page.total_entries,
         distance: @pagination_distance,
         sort_field: sort_field,
         sort_direction: sort_direction
       }}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  defp do_paginate_order_item_extras(filter, params) do
    OrderItemExtra
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of order_item_extras.

  ## Examples

      iex> list_order_item_extras()
      [%OrderItemExtra{}, ...]

  """
  def list_order_item_extras do
    Repo.all(OrderItemExtra)
  end

  @doc """
  Gets a single order_item_extra.

  Raises `Ecto.NoResultsError` if the Order item extra does not exist.

  ## Examples

      iex> get_order_item_extra!(123)
      %OrderItemExtra{}

      iex> get_order_item_extra!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_item_extra!(id), do: Repo.get!(OrderItemExtra, id)

  @doc """
  Creates a order_item_extra.

  ## Examples

      iex> create_order_item_extra(%{field: value})
      {:ok, %OrderItemExtra{}}

      iex> create_order_item_extra(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_item_extra(attrs \\ %{}) do
    %OrderItemExtra{}
    |> OrderItemExtra.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order_item_extra.

  ## Examples

      iex> update_order_item_extra(order_item_extra, %{field: new_value})
      {:ok, %OrderItemExtra{}}

      iex> update_order_item_extra(order_item_extra, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_item_extra(%OrderItemExtra{} = order_item_extra, attrs) do
    order_item_extra
    |> OrderItemExtra.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a OrderItemExtra.

  ## Examples

      iex> delete_order_item_extra(order_item_extra)
      {:ok, %OrderItemExtra{}}

      iex> delete_order_item_extra(order_item_extra)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_item_extra(%OrderItemExtra{} = order_item_extra) do
    Repo.delete(order_item_extra)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_item_extra changes.

  ## Examples

      iex> change_order_item_extra(order_item_extra)
      %Ecto.Changeset{source: %OrderItemExtra{}}

  """
  def change_order_item_extra(%OrderItemExtra{} = order_item_extra, attrs \\ %{}) do
    OrderItemExtra.changeset(order_item_extra, attrs)
  end

  import Torch.Helpers, only: [sort: 1, paginate: 4, strip_unset_booleans: 3]
  import Filtrex.Type.Config

  alias Lunchbot.LunchbotData.Extra

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of extras using filtrex
  filters.

  ## Examples

      iex> paginate_extras(%{})
      %{extras: [%Extra{}], ...}

  """
  @spec paginate_extras(map) :: {:ok, map} | {:error, any}
  def paginate_extras(params \\ %{}) do
    params =
      params
      |> strip_unset_booleans("extra", [])
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:extras), params["extra"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_extras(filter, params) do
      {:ok,
       %{
         extras: page.entries,
         page_number: page.page_number,
         page_size: page.page_size,
         total_pages: page.total_pages,
         total_entries: page.total_entries,
         distance: @pagination_distance,
         sort_field: sort_field,
         sort_direction: sort_direction
       }}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  defp do_paginate_extras(filter, params) do
    Extra
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of extras.

  ## Examples

      iex> list_extras()
      [%Extra{}, ...]

  """
  def list_extras do
    Repo.all(Extra)
  end

  @doc """
  Gets a single extra.

  Raises `Ecto.NoResultsError` if the Extra does not exist.

  ## Examples

      iex> get_extra!(123)
      %Extra{}

      iex> get_extra!(456)
      ** (Ecto.NoResultsError)

  """
  def get_extra!(id), do: Repo.get!(Extra, id)

  @doc """
  Creates a extra.

  ## Examples

      iex> create_extra(%{field: value})
      {:ok, %Extra{}}

      iex> create_extra(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_extra(attrs \\ %{}) do
    %Extra{}
    |> Extra.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a extra.

  ## Examples

      iex> update_extra(extra, %{field: new_value})
      {:ok, %Extra{}}

      iex> update_extra(extra, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_extra(%Extra{} = extra, attrs) do
    extra
    |> Extra.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Extra.

  ## Examples

      iex> delete_extra(extra)
      {:ok, %Extra{}}

      iex> delete_extra(extra)
      {:error, %Ecto.Changeset{}}

  """
  def delete_extra(%Extra{} = extra) do
    Repo.delete(extra)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking extra changes.

  ## Examples

      iex> change_extra(extra)
      %Ecto.Changeset{source: %Extra{}}

  """
  def change_extra(%Extra{} = extra, attrs \\ %{}) do
    Extra.changeset(extra, attrs)
  end

  defp filter_config(:offices) do
    defconfig do
      text(:timezone)
    end
  end

  defp filter_config(:menus) do
    defconfig do
      text(:name)
      number(:office_id)
    end
  end

  defp filter_config(:office_lunch_orders) do
    defconfig do
      date(:day)
      number(:office_id)
    end
  end

  defp filter_config(:orders) do
    defconfig do
      number(:user_id)
      number(:menu_id)
      number(:lunch_order_id)
    end
  end

  defp filter_config(:categories) do
    defconfig do
      text(:name)
      number(:menu_id)
    end
  end

  defp filter_config(:order_items) do
    defconfig do
      number(:order_id)
      number(:item_id)
    end
  end

  defp filter_config(:items) do
    defconfig do
      text(:name)
      number(:category_id)
      text(:image_url)
      boolean(:deleted)
    end
  end

  defp filter_config(:order_item_extras) do
    defconfig do
      number(:order_item_id)
      number(:extra_id)
    end
  end

  defp filter_config(:extras) do
    defconfig do
      text(:name)
      number(:item_id)
    end
  end
end
