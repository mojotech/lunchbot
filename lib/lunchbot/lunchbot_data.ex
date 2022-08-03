defmodule Lunchbot.LunchbotData do
  @moduledoc """
  The LunchbotData context.
  """

  import Ecto.Query, warn: false
  alias Lunchbot.Repo
  import Torch.Helpers, only: [sort: 1, paginate: 4, strip_unset_booleans: 3]
  import Filtrex.Type.Config

  alias Lunchbot.LunchbotData.{
    Office,
    Options,
    Item,
    Menu,
    OfficeLunchOrder,
    Order,
    Category,
    OrderItem,
    OptionHeading,
    ItemOptionHeadings,
    OrderItemOptions,
    MenuCategories
  }

  alias Lunchbot.Accounts.User

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

  def list_menu_name_id_tuples do
    Repo.all(Menu)
    |> Enum.map(&{&1.name, &1.id})
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

  def get_all_menu_data(id) do
    Repo.get(Menu, id)
    |> Repo.preload(categories: [items: [option_headings: [:options]]])
    |> Map.from_struct()
  end

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

  def get_office_lunch_order_ids(office_id) do
    today = Date.utc_today()

    office_lunch_order_id_query =
      from olo in "office_lunch_orders",
        select: [olo.id, olo.menu_id],
        where: olo.day >= ^today and olo.office_id == ^office_id,
        order_by: [asc: :day],
        limit: 1

    Repo.all(office_lunch_order_id_query)
    |> Enum.at(0)
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

  def list_preloaded_orders do
    yesterday = Date.add(Date.utc_today(), 0)

    lunch_order_id =
      from(olo in OfficeLunchOrder,
        select: olo.id,
        where: olo.day == ^yesterday
      )
      |> Repo.all()
      |> Enum.at(0)

    if !is_nil(lunch_order_id) do
      from(o in Order,
        where: o.lunch_order_id == ^lunch_order_id,
        preload: [
          user: ^from(u in User, select: u.name),
          order_items: [
            options: ^from(op in Options, select: op.name),
            item: ^from(i in Item, select: i.name)
          ]
        ]
      )
      |> Repo.all()
    else
      nil
    end
  end

  def format_orders(order_struct) do
    if !is_nil(order_struct) do
      orders =
        for order <- order_struct do
          timestamp = order.inserted_at
          user = order.user

          order_items =
            for order_item <- order.order_items do
              item_with_options =
                for order_item_option <- order_item.options do
                  order_item_option
                end
                |> Enum.join(", ")

              if String.length(item_with_options) > 0 do
                order_item.item <>
                  " w/ options: " <>
                  item_with_options
              else
                order_item.item
              end
            end

          [
            timestamp,
            user,
            for item <- order_items do
              item
            end
          ]
          |> List.flatten()
        end

      orders
    else
      nil
    end
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
    |> OrderItem.notify_subscribers([:order_item, :created])
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
    |> OrderItem.notify_subscribers([:order_item, :updated])
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
    |> OrderItem.notify_subscribers([:order_item, :deleted])
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

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of item_option_headings using filtrex
  filters.

  ## Examples

      iex> paginate_item_option_headings(%{})
      %{item_option_headings: [%ItemOptionHeadings{}], ...}

  """
  @spec paginate_item_option_headings(map) :: {:ok, map} | {:error, any}
  def paginate_item_option_headings(params \\ %{}) do
    params =
      params
      |> strip_unset_booleans("item_option_headings", [])
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <-
           Filtrex.parse_params(
             filter_config(:item_option_headings),
             params["item_option_headings"] || %{}
           ),
         %Scrivener.Page{} = page <- do_paginate_item_option_headings(filter, params) do
      {:ok,
       %{
         item_option_headings: page.entries,
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

  defp do_paginate_item_option_headings(filter, params) do
    ItemOptionHeadings
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of item_option_headings.

  ## Examples

      iex> list_item_option_headings()
      [%ItemOptionHeadings{}, ...]

  """
  def list_item_option_headings do
    Repo.all(ItemOptionHeadings)
  end

  @doc """
  Gets a single item_option_headings.

  Raises `Ecto.NoResultsError` if the Item option headings does not exist.

  ## Examples

      iex> get_item_option_headings!(123)
      %ItemOptionHeadings{}

      iex> get_item_option_headings!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item_option_headings!(id), do: Repo.get!(ItemOptionHeadings, id)

  @doc """
  Creates a item_option_headings.

  ## Examples

      iex> create_item_option_headings(%{field: value})
      {:ok, %ItemOptionHeadings{}}

      iex> create_item_option_headings(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item_option_headings(attrs \\ %{}) do
    %ItemOptionHeadings{}
    |> ItemOptionHeadings.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item_option_headings.

  ## Examples

      iex> update_item_option_headings(item_option_headings, %{field: new_value})
      {:ok, %ItemOptionHeadings{}}

      iex> update_item_option_headings(item_option_headings, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item_option_headings(%ItemOptionHeadings{} = item_option_headings, attrs) do
    item_option_headings
    |> ItemOptionHeadings.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ItemOptionHeadings.

  ## Examples

      iex> delete_item_option_headings(item_option_headings)
      {:ok, %ItemOptionHeadings{}}

      iex> delete_item_option_headings(item_option_headings)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item_option_headings(%ItemOptionHeadings{} = item_option_headings) do
    Repo.delete(item_option_headings)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item_option_headings changes.

  ## Examples

      iex> change_item_option_headings(item_option_headings)
      %Ecto.Changeset{source: %ItemOptionHeadings{}}

  """
  def change_item_option_headings(%ItemOptionHeadings{} = item_option_headings, attrs \\ %{}) do
    ItemOptionHeadings.changeset(item_option_headings, attrs)
  end

  import Torch.Helpers, only: [sort: 1, paginate: 4, strip_unset_booleans: 3]
  import Filtrex.Type.Config

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of option_headings using filtrex
  filters.

  ## Examples

      iex> paginate_option_headings(%{})
      %{option_headings: [%OptionHeadings{}], ...}

  """
  @spec paginate_option_headings(map) :: {:ok, map} | {:error, any}
  def paginate_option_headings(params \\ %{}) do
    params =
      params
      |> strip_unset_booleans("option_headings", [])
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <-
           Filtrex.parse_params(filter_config(:option_headings), params["option_headings"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_option_headings(filter, params) do
      {:ok,
       %{
         option_headings: page.entries,
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

  defp do_paginate_option_headings(filter, params) do
    OptionHeading
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of option_headings.

  ## Examples

      iex> list_option_headings()
      [%OptionHeading{}, ...]

  """
  def list_option_headings do
    Repo.all(OptionHeading)
  end

  @doc """
  Gets a single option_headings.

  Raises `Ecto.NoResultsError` if the Option headings does not exist.

  ## Examples

      iex> get_option_headings!(123)
      %OptionHeadings{}

      iex> get_option_headings!(456)
      ** (Ecto.NoResultsError)

  """
  def get_option_headings!(id), do: Repo.get!(OptionHeading, id)

  @doc """
  Creates a option_headings.

  ## Examples

      iex> create_option_headings(%{field: value})
      {:ok, %OptionHeading{}}

      iex> create_option_headings(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_option_headings(attrs \\ %{}) do
    %OptionHeading{}
    |> OptionHeading.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a option_headings.

  ## Examples

      iex> update_option_headings(option_headings, %{field: new_value})
      {:ok, %OptionHeadings{}}

      iex> update_option_headings(option_headings, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_option_headings(%OptionHeading{} = option_headings, attrs) do
    option_headings
    |> OptionHeading.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a OptionHeadings.

  ## Examples

      iex> delete_option_headings(option_headings)
      {:ok, %OptionHeadings{}}

      iex> delete_option_headings(option_headings)
      {:error, %Ecto.Changeset{}}

  """
  def delete_option_headings(%OptionHeading{} = option_headings) do
    Repo.delete(option_headings)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking option_headings changes.

  ## Examples

      iex> change_option_headings(option_headings)
      %Ecto.Changeset{source: %OptionHeading{}}

  """
  def change_option_headings(%OptionHeading{} = option_headings, attrs \\ %{}) do
    OptionHeading.changeset(option_headings, attrs)
  end

  import Torch.Helpers, only: [sort: 1, paginate: 4, strip_unset_booleans: 3]
  import Filtrex.Type.Config

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of order_item_options using filtrex
  filters.

  ## Examples

      iex> paginate_order_item_options(%{})
      %{order_item_options: [%OrderItemOptions{}], ...}

  """
  @spec paginate_order_item_options(map) :: {:ok, map} | {:error, any}
  def paginate_order_item_options(params \\ %{}) do
    params =
      params
      |> strip_unset_booleans("order_item_options", [])
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <-
           Filtrex.parse_params(
             filter_config(:order_item_options),
             params["order_item_options"] || %{}
           ),
         %Scrivener.Page{} = page <- do_paginate_order_item_options(filter, params) do
      {:ok,
       %{
         order_item_options: page.entries,
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

  defp do_paginate_order_item_options(filter, params) do
    OrderItemOptions
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of order_item_options.

  ## Examples

      iex> list_order_item_options()
      [%OrderItemOptions{}, ...]

  """
  def list_order_item_options do
    Repo.all(OrderItemOptions)
  end

  @doc """
  Gets a single order_item_options.

  Raises `Ecto.NoResultsError` if the Order item options does not exist.

  ## Examples

      iex> get_order_item_options!(123)
      %OrderItemOptions{}

      iex> get_order_item_options!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_item_options!(id), do: Repo.get!(OrderItemOptions, id)

  @doc """
  Creates a order_item_options.

  ## Examples

      iex> create_order_item_options(%{field: value})
      {:ok, %OrderItemOptions{}}

      iex> create_order_item_options(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_item_options(attrs \\ %{}) do
    %OrderItemOptions{}
    |> OrderItemOptions.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order_item_options.

  ## Examples

      iex> update_order_item_options(order_item_options, %{field: new_value})
      {:ok, %OrderItemOptions{}}

      iex> update_order_item_options(order_item_options, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_item_options(%OrderItemOptions{} = order_item_options, attrs) do
    order_item_options
    |> OrderItemOptions.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a OrderItemOptions.

  ## Examples

      iex> delete_order_item_options(order_item_options)
      {:ok, %OrderItemOptions{}}

      iex> delete_order_item_options(order_item_options)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_item_options(%OrderItemOptions{} = order_item_options) do
    Repo.delete(order_item_options)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_item_options changes.

  ## Examples

      iex> change_order_item_options(order_item_options)
      %Ecto.Changeset{source: %OrderItemOptions{}}

  """
  def change_order_item_options(%OrderItemOptions{} = order_item_options, attrs \\ %{}) do
    OrderItemOptions.changeset(order_item_options, attrs)
  end

  import Torch.Helpers, only: [sort: 1, paginate: 4, strip_unset_booleans: 3]
  import Filtrex.Type.Config

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of options using filtrex
  filters.

  ## Examples

      iex> paginate_options(%{})
      %{options: [%Options{}], ...}

  """
  @spec paginate_options(map) :: {:ok, map} | {:error, any}
  def paginate_options(params \\ %{}) do
    params =
      params
      |> strip_unset_booleans("options", [:preselected, :is_required, :extras])
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:options), params["options"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_options(filter, params) do
      {:ok,
       %{
         options: page.entries,
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

  defp do_paginate_options(filter, params) do
    Options
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of options.

  ## Examples

      iex> list_options()
      [%Options{}, ...]

  """
  def list_options do
    Repo.all(Options)
  end

  @doc """
  Gets a single options.

  Raises `Ecto.NoResultsError` if the Options does not exist.

  ## Examples

      iex> get_options!(123)
      %Options{}

      iex> get_options!(456)
      ** (Ecto.NoResultsError)

  """
  def get_options!(id), do: Repo.get!(Options, id)

  def get_selected_options(menu_id, selected_options) do
    option_ids_query =
      from o in "options",
        join: m in Lunchbot.LunchbotData.Menu,
        on: m.id == ^menu_id,
        where: o.name in ^selected_options,
        select: o.id

    Repo.all(option_ids_query)
  end

  @doc """
  Creates a options.

  ## Examples

      iex> create_options(%{field: value})
      {:ok, %Options{}}

      iex> create_options(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_options(attrs \\ %{}) do
    %Options{}
    |> Options.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a options.

  ## Examples

      iex> update_options(options, %{field: new_value})
      {:ok, %Options{}}

      iex> update_options(options, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_options(%Options{} = options, attrs) do
    options
    |> Options.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Options.

  ## Examples

      iex> delete_options(options)
      {:ok, %Options{}}

      iex> delete_options(options)
      {:error, %Ecto.Changeset{}}

  """
  def delete_options(%Options{} = options) do
    Repo.delete(options)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking options changes.

  ## Examples

      iex> change_options(options)
      %Ecto.Changeset{source: %Options{}}

  """
  def change_options(%Options{} = options, attrs \\ %{}) do
    Options.changeset(options, attrs)
  end

  import Torch.Helpers, only: [sort: 1, paginate: 4, strip_unset_booleans: 3]
  import Filtrex.Type.Config

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of menu_categories using filtrex
  filters.

  ## Examples

      iex> paginate_menu_categories(%{})
      %{menu_categories: [%MenuCategories{}], ...}

  """
  @spec paginate_menu_categories(map) :: {:ok, map} | {:error, any}
  def paginate_menu_categories(params \\ %{}) do
    params =
      params
      |> strip_unset_booleans("menu_categories", [])
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <-
           Filtrex.parse_params(filter_config(:menu_categories), params["menu_categories"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_menu_categories(filter, params) do
      {:ok,
       %{
         menu_categories: page.entries,
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

  defp do_paginate_menu_categories(filter, params) do
    MenuCategories
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  @doc """
  Returns the list of menu_categories.

  ## Examples

      iex> list_menu_categories()
      [%MenuCategories{}, ...]

  """
  def list_menu_categories do
    Repo.all(MenuCategories)
  end

  @doc """
  Gets a single menu_categories.

  Raises `Ecto.NoResultsError` if the Menu categories does not exist.

  ## Examples

      iex> get_menu_categories!(123)
      %MenuCategories{}

      iex> get_menu_categories!(456)
      ** (Ecto.NoResultsError)

  """
  def get_menu_categories!(id), do: Repo.get!(MenuCategories, id)

  @doc """
  Creates a menu_categories.

  ## Examples

      iex> create_menu_categories(%{field: value})
      {:ok, %MenuCategories{}}

      iex> create_menu_categories(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_menu_categories(attrs \\ %{}) do
    %MenuCategories{}
    |> MenuCategories.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a menu_categories.

  ## Examples

      iex> update_menu_categories(menu_categories, %{field: new_value})
      {:ok, %MenuCategories{}}

      iex> update_menu_categories(menu_categories, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_menu_categories(%MenuCategories{} = menu_categories, attrs) do
    menu_categories
    |> MenuCategories.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MenuCategories.

  ## Examples

      iex> delete_menu_categories(menu_categories)
      {:ok, %MenuCategories{}}

      iex> delete_menu_categories(menu_categories)
      {:error, %Ecto.Changeset{}}

  """
  def delete_menu_categories(%MenuCategories{} = menu_categories) do
    Repo.delete(menu_categories)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking menu_categories changes.

  ## Examples

      iex> change_menu_categories(menu_categories)
      %Ecto.Changeset{source: %MenuCategories{}}

  """
  def change_menu_categories(%MenuCategories{} = menu_categories, attrs \\ %{}) do
    MenuCategories.changeset(menu_categories, attrs)
  end

  defp filter_config(:offices) do
    defconfig do
      text(:timezone)
      text(:name)
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
      text(:description)
      number(:price)
      text(:item_image)
      number(:category_id)
      text(:image_url)
      boolean(:deleted)
    end
  end

  defp filter_config(:item_option_headings) do
    defconfig do
      number(:item_id)
      number(:option_heading_id)
    end
  end

  defp filter_config(:option_headings) do
    defconfig do
      text(:name)
      number(:priority)
    end
  end

  defp filter_config(:order_item_options) do
    defconfig do
      number(:order_item_id)
      number(:option_id)
    end
  end

  defp filter_config(:options) do
    defconfig do
      text(:name)
      number(:option_heading_id)
      boolean(:extras)
      number(:price)
      number(:extra_price)
      boolean(:is_required)
      boolean(:preselected)
    end
  end

  defp filter_config(:menu_categories) do
    defconfig do
      number(:category_id)
      number(:menu_id)
    end
  end
end
