defmodule Lunchbot.LunchbotDataTest do
  use Lunchbot.DataCase

  alias Lunchbot.LunchbotData

  alias Lunchbot.Accounts

  alias Lunchbot.Accounts.User

  @valid_attrs %{
    name: "some name",
    email: "some email",
    role: "some role",
    password: "some password",
    hashed_password: "some hashed password",
    confirmed_at: ~N[2000-01-01 23:00:07]
  }
  @update_attrs %{
    name: "some updated name",
    email: "some updated email",
    role: "some updated role",
    password: "some updated password",
    hashed_password: "some updated hashed password",
    confirmed_at: ~N[2001-01-01 23:00:07]
  }
  @invalid_attrs %{name: nil, email: nil, role: nil}

  describe "#paginate_users/1" do
    test "returns paginated list of users" do
      for i <- 1..20 do
        # We do this since our user's emails must be unique
        curr_attrs = Map.replace!(@valid_attrs, :email, "#{Map.get(@valid_attrs, :email)}#{i}")

        curr_attrs
        |> Enum.into(curr_attrs)
        |> Accounts.create_user()
      end

      {:ok, %{users: users} = page} = Accounts.paginate_users(%{})

      assert length(users) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_users/0" do
    test "returns all users" do
      user = Map.replace!(user_fixture(), :password, nil)
      assert Accounts.list_users() == [user]
    end
  end

  describe "#get_user!/1" do
    test "returns the user with given id" do
      user = Map.replace!(user_fixture(), :password, nil)
      assert Accounts.get_user!(user.id) == user
    end
  end

  describe "#create_user/1" do
    test "with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.name == "some name"
      assert user.email == "some email"
      assert user.role == "some role"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end
  end

  describe "#update_user/2" do
    test "with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.name == "some updated name"
      assert user.email == "some updated email"
      assert user.role == "some updated role"
    end

    test "with invalid data returns error changeset" do
      user = Map.replace!(user_fixture(), :password, nil)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end
  end

  describe "#delete_user/1" do
    test "deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end
  end

  describe "#change_user/1" do
    test "returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Accounts.create_user()

    user
  end

  alias Lunchbot.LunchbotData.Office

  @valid_attrs %{name: "some name", timezone: "some timezone"}
  @update_attrs %{name: "some updated name", timezone: "some updated timezone"}
  @invalid_attrs %{name: nil, timezone: nil}

  describe "#paginate_offices/1" do
    test "returns paginated list of offices" do
      for _ <- 1..20 do
        office_fixture()
      end

      {:ok, %{offices: offices} = page} = LunchbotData.paginate_offices(%{})

      assert length(offices) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_offices/0" do
    test "returns all offices" do
      office = office_fixture()
      assert LunchbotData.list_offices() == [office]
    end
  end

  describe "#get_office!/1" do
    test "returns the office with given id" do
      office = office_fixture()
      assert LunchbotData.get_office!(office.id) == office
    end
  end

  describe "#create_office/1" do
    test "with valid data creates a office" do
      assert {:ok, %Office{} = office} = LunchbotData.create_office(@valid_attrs)
      assert office.name == "some name"
      assert office.timezone == "some timezone"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_office(@invalid_attrs)
    end
  end

  describe "#update_office/2" do
    test "with valid data updates the office" do
      office = office_fixture()
      assert {:ok, office} = LunchbotData.update_office(office, @update_attrs)
      assert %Office{} = office
      assert office.name == "some updated name"
      assert office.timezone == "some updated timezone"
    end

    test "with invalid data returns error changeset" do
      office = office_fixture()
      assert {:error, %Ecto.Changeset{}} = LunchbotData.update_office(office, @invalid_attrs)
      assert office == LunchbotData.get_office!(office.id)
    end
  end

  describe "#delete_office/1" do
    test "deletes the office" do
      office = office_fixture()
      assert {:ok, %Office{}} = LunchbotData.delete_office(office)
      assert_raise Ecto.NoResultsError, fn -> LunchbotData.get_office!(office.id) end
    end
  end

  describe "#change_office/1" do
    test "returns a office changeset" do
      office = office_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_office(office)
    end
  end

  def office_fixture(attrs \\ %{}) do
    {:ok, office} =
      attrs
      |> Enum.into(@valid_attrs)
      |> LunchbotData.create_office()

    office
  end

  alias Lunchbot.LunchbotData.Menu

  @valid_attrs %{name: "some name", office_id: 42}
  @update_attrs %{name: "some updated name", office_id: 43}
  @invalid_attrs %{name: nil, office_id: nil}

  describe "#paginate_menus/1" do
    test "returns paginated list of menus" do
      for _ <- 1..20 do
        menu_fixture()
      end

      {:ok, %{menus: menus} = page} = LunchbotData.paginate_menus(%{})

      assert length(menus) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_menus/0" do
    test "returns all menus" do
      menu = menu_fixture()
      assert LunchbotData.list_menus() == [menu]
    end
  end

  describe "#get_menu!/1" do
    test "returns the menu with given id" do
      menu = menu_fixture()
      assert LunchbotData.get_menu!(menu.id) == menu
    end
  end

  describe "#create_menu/1" do
    test "with valid data creates a menu" do
      assert {:ok, %Menu{} = menu} = LunchbotData.create_menu(@valid_attrs)
      assert menu.name == "some name"
      assert menu.office_id == 42
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_menu(@invalid_attrs)
    end
  end

  describe "#update_menu/2" do
    test "with valid data updates the menu" do
      menu = menu_fixture()
      assert {:ok, menu} = LunchbotData.update_menu(menu, @update_attrs)
      assert %Menu{} = menu
      assert menu.name == "some updated name"
      assert menu.office_id == 43
    end

    test "with invalid data returns error changeset" do
      menu = menu_fixture()
      assert {:error, %Ecto.Changeset{}} = LunchbotData.update_menu(menu, @invalid_attrs)
      assert menu == LunchbotData.get_menu!(menu.id)
    end
  end

  describe "#delete_menu/1" do
    test "deletes the menu" do
      menu = menu_fixture()
      assert {:ok, %Menu{}} = LunchbotData.delete_menu(menu)
      assert_raise Ecto.NoResultsError, fn -> LunchbotData.get_menu!(menu.id) end
    end
  end

  describe "#change_menu/1" do
    test "returns a menu changeset" do
      menu = menu_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_menu(menu)
    end
  end

  def menu_fixture(attrs \\ %{}) do
    {:ok, menu} =
      attrs
      |> Enum.into(@valid_attrs)
      |> LunchbotData.create_menu()

    menu
  end

  alias Lunchbot.LunchbotData.OfficeLunchOrder

  @valid_attrs %{day: ~D[2022-07-07], office_id: 42}
  @update_attrs %{day: ~D[2022-07-08], office_id: 43}
  @invalid_attrs %{day: nil, office_id: nil}

  describe "#paginate_office_lunch_orders/1" do
    test "returns paginated list of office_lunch_orders" do
      for _ <- 1..20 do
        office_lunch_order_fixture()
      end

      {:ok, %{office_lunch_orders: office_lunch_orders} = page} =
        LunchbotData.paginate_office_lunch_orders(%{})

      assert length(office_lunch_orders) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_office_lunch_orders/0" do
    test "returns all office_lunch_orders" do
      office_lunch_order = office_lunch_order_fixture()
      assert LunchbotData.list_office_lunch_orders() == [office_lunch_order]
    end
  end

  describe "#get_office_lunch_order!/1" do
    test "returns the office_lunch_order with given id" do
      office_lunch_order = office_lunch_order_fixture()
      assert LunchbotData.get_office_lunch_order!(office_lunch_order.id) == office_lunch_order
    end
  end

  describe "#create_office_lunch_order/1" do
    test "with valid data creates a office_lunch_order" do
      assert {:ok, %OfficeLunchOrder{} = office_lunch_order} =
               LunchbotData.create_office_lunch_order(@valid_attrs)

      assert office_lunch_order.day == ~D[2022-07-07]
      assert office_lunch_order.office_id == 42
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_office_lunch_order(@invalid_attrs)
    end
  end

  describe "#update_office_lunch_order/2" do
    test "with valid data updates the office_lunch_order" do
      office_lunch_order = office_lunch_order_fixture()

      assert {:ok, office_lunch_order} =
               LunchbotData.update_office_lunch_order(office_lunch_order, @update_attrs)

      assert %OfficeLunchOrder{} = office_lunch_order
      assert office_lunch_order.day == ~D[2022-07-08]
      assert office_lunch_order.office_id == 43
    end

    test "with invalid data returns error changeset" do
      office_lunch_order = office_lunch_order_fixture()

      assert {:error, %Ecto.Changeset{}} =
               LunchbotData.update_office_lunch_order(office_lunch_order, @invalid_attrs)

      assert office_lunch_order == LunchbotData.get_office_lunch_order!(office_lunch_order.id)
    end
  end

  describe "#delete_office_lunch_order/1" do
    test "deletes the office_lunch_order" do
      office_lunch_order = office_lunch_order_fixture()

      assert {:ok, %OfficeLunchOrder{}} =
               LunchbotData.delete_office_lunch_order(office_lunch_order)

      assert_raise Ecto.NoResultsError, fn ->
        LunchbotData.get_office_lunch_order!(office_lunch_order.id)
      end
    end
  end

  describe "#change_office_lunch_order/1" do
    test "returns a office_lunch_order changeset" do
      office_lunch_order = office_lunch_order_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_office_lunch_order(office_lunch_order)
    end
  end

  def office_lunch_order_fixture(attrs \\ %{}) do
    {:ok, office_lunch_order} =
      attrs
      |> Enum.into(@valid_attrs)
      |> LunchbotData.create_office_lunch_order()

    office_lunch_order
  end

  alias Lunchbot.LunchbotData.Order

  @valid_attrs %{lunch_order_id: 42, menu_id: 42, user_id: 42}
  @update_attrs %{lunch_order_id: 43, menu_id: 43, user_id: 43}
  @invalid_attrs %{lunch_order_id: nil, menu_id: nil, user_id: nil}

  describe "#paginate_orders/1" do
    test "returns paginated list of orders" do
      for _ <- 1..20 do
        order_fixture()
      end

      {:ok, %{orders: orders} = page} = LunchbotData.paginate_orders(%{})

      assert length(orders) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_orders/0" do
    test "returns all orders" do
      order = order_fixture()
      assert LunchbotData.list_orders() == [order]
    end
  end

  describe "#get_order!/1" do
    test "returns the order with given id" do
      order = order_fixture()
      assert LunchbotData.get_order!(order.id) == order
    end
  end

  describe "#create_order/1" do
    test "with valid data creates a order" do
      assert {:ok, %Order{} = order} = LunchbotData.create_order(@valid_attrs)
      assert order.lunch_order_id == 42
      assert order.menu_id == 42
      assert order.user_id == 42
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_order(@invalid_attrs)
    end
  end

  describe "#update_order/2" do
    test "with valid data updates the order" do
      order = order_fixture()
      assert {:ok, order} = LunchbotData.update_order(order, @update_attrs)
      assert %Order{} = order
      assert order.lunch_order_id == 43
      assert order.menu_id == 43
      assert order.user_id == 43
    end

    test "with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = LunchbotData.update_order(order, @invalid_attrs)
      assert order == LunchbotData.get_order!(order.id)
    end
  end

  describe "#delete_order/1" do
    test "deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = LunchbotData.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> LunchbotData.get_order!(order.id) end
    end
  end

  describe "#change_order/1" do
    test "returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_order(order)
    end
  end

  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(@valid_attrs)
      |> LunchbotData.create_order()

    order
  end

  alias Lunchbot.LunchbotData.Category

  @valid_attrs %{menu_id: 42, name: "some name"}
  @update_attrs %{menu_id: 43, name: "some updated name"}
  @invalid_attrs %{menu_id: nil, name: nil}

  describe "#paginate_categories/1" do
    test "returns paginated list of categories" do
      for _ <- 1..20 do
        category_fixture()
      end

      {:ok, %{categories: categories} = page} = LunchbotData.paginate_categories(%{})

      assert length(categories) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_categories/0" do
    test "returns all categories" do
      category = category_fixture()
      assert LunchbotData.list_categories() == [category]
    end
  end

  describe "#get_category!/1" do
    test "returns the category with given id" do
      category = category_fixture()
      assert LunchbotData.get_category!(category.id) == category
    end
  end

  describe "#create_category/1" do
    test "with valid data creates a category" do
      assert {:ok, %Category{} = category} = LunchbotData.create_category(@valid_attrs)
      assert category.menu_id == 42
      assert category.name == "some name"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_category(@invalid_attrs)
    end
  end

  describe "#update_category/2" do
    test "with valid data updates the category" do
      category = category_fixture()
      assert {:ok, category} = LunchbotData.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.menu_id == 43
      assert category.name == "some updated name"
    end

    test "with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = LunchbotData.update_category(category, @invalid_attrs)
      assert category == LunchbotData.get_category!(category.id)
    end
  end

  describe "#delete_category/1" do
    test "deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = LunchbotData.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> LunchbotData.get_category!(category.id) end
    end
  end

  describe "#change_category/1" do
    test "returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_category(category)
    end
  end

  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(@valid_attrs)
      |> LunchbotData.create_category()

    category
  end

  alias Lunchbot.LunchbotData.OrderItem

  @valid_attrs %{item_id: 42, order_id: 42}
  @update_attrs %{item_id: 43, order_id: 43}
  @invalid_attrs %{item_id: nil, order_id: nil}

  describe "#paginate_order_items/1" do
    test "returns paginated list of order_items" do
      for _ <- 1..20 do
        order_item_fixture()
      end

      {:ok, %{order_items: order_items} = page} = LunchbotData.paginate_order_items(%{})

      assert length(order_items) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_order_items/0" do
    test "returns all order_items" do
      order_item = order_item_fixture()
      assert LunchbotData.list_order_items() == [order_item]
    end
  end

  describe "#get_order_item!/1" do
    test "returns the order_item with given id" do
      order_item = order_item_fixture()
      assert LunchbotData.get_order_item!(order_item.id) == order_item
    end
  end

  describe "#create_order_item/1" do
    test "with valid data creates a order_item" do
      assert {:ok, %OrderItem{} = order_item} = LunchbotData.create_order_item(@valid_attrs)
      assert order_item.item_id == 42
      assert order_item.order_id == 42
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_order_item(@invalid_attrs)
    end
  end

  describe "#update_order_item/2" do
    test "with valid data updates the order_item" do
      order_item = order_item_fixture()
      assert {:ok, order_item} = LunchbotData.update_order_item(order_item, @update_attrs)
      assert %OrderItem{} = order_item
      assert order_item.item_id == 43
      assert order_item.order_id == 43
    end

    test "with invalid data returns error changeset" do
      order_item = order_item_fixture()

      assert {:error, %Ecto.Changeset{}} =
               LunchbotData.update_order_item(order_item, @invalid_attrs)

      assert order_item == LunchbotData.get_order_item!(order_item.id)
    end
  end

  describe "#delete_order_item/1" do
    test "deletes the order_item" do
      order_item = order_item_fixture()
      assert {:ok, %OrderItem{}} = LunchbotData.delete_order_item(order_item)
      assert_raise Ecto.NoResultsError, fn -> LunchbotData.get_order_item!(order_item.id) end
    end
  end

  describe "#change_order_item/1" do
    test "returns a order_item changeset" do
      order_item = order_item_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_order_item(order_item)
    end
  end

  def order_item_fixture(attrs \\ %{}) do
    {:ok, order_item} =
      attrs
      |> Enum.into(@valid_attrs)
      |> LunchbotData.create_order_item()

    order_item
  end

  alias Lunchbot.LunchbotData.Item

  @valid_attrs %{category_id: 42, deleted: true, image_url: "some image_url", name: "some name"}
  @update_attrs %{
    category_id: 43,
    deleted: false,
    image_url: "some updated image_url",
    name: "some updated name"
  }
  @invalid_attrs %{category_id: nil, deleted: nil, image_url: nil, name: nil}

  describe "#paginate_items/1" do
    test "returns paginated list of items" do
      for _ <- 1..20 do
        item_fixture()
      end

      {:ok, %{items: items} = page} = LunchbotData.paginate_items(%{})

      assert length(items) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_items/0" do
    test "returns all items" do
      item = item_fixture()
      assert LunchbotData.list_items() == [item]
    end
  end

  describe "#get_item!/1" do
    test "returns the item with given id" do
      item = item_fixture()
      assert LunchbotData.get_item!(item.id) == item
    end
  end

  describe "#create_item/1" do
    test "with valid data creates a item" do
      assert {:ok, %Item{} = item} = LunchbotData.create_item(@valid_attrs)
      assert item.category_id == 42
      assert item.deleted == true
      assert item.image_url == "some image_url"
      assert item.name == "some name"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_item(@invalid_attrs)
    end
  end

  describe "#update_item/2" do
    test "with valid data updates the item" do
      item = item_fixture()
      assert {:ok, item} = LunchbotData.update_item(item, @update_attrs)
      assert %Item{} = item
      assert item.category_id == 43
      assert item.deleted == false
      assert item.image_url == "some updated image_url"
      assert item.name == "some updated name"
    end

    test "with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = LunchbotData.update_item(item, @invalid_attrs)
      assert item == LunchbotData.get_item!(item.id)
    end
  end

  describe "#delete_item/1" do
    test "deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = LunchbotData.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> LunchbotData.get_item!(item.id) end
    end
  end

  describe "#change_item/1" do
    test "returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_item(item)
    end
  end

  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(@valid_attrs)
      |> LunchbotData.create_item()

    item
  end

  alias Lunchbot.LunchbotData.OrderItemExtra

  @valid_attrs %{extra_id: 42, order_item_id: 42}
  @update_attrs %{extra_id: 43, order_item_id: 43}
  @invalid_attrs %{extra_id: nil, order_item_id: nil}

  describe "#paginate_order_item_extras/1" do
    test "returns paginated list of order_item_extras" do
      for _ <- 1..20 do
        order_item_extra_fixture()
      end

      {:ok, %{order_item_extras: order_item_extras} = page} =
        LunchbotData.paginate_order_item_extras(%{})

      assert length(order_item_extras) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_order_item_extras/0" do
    test "returns all order_item_extras" do
      order_item_extra = order_item_extra_fixture()
      assert LunchbotData.list_order_item_extras() == [order_item_extra]
    end
  end

  describe "#get_order_item_extra!/1" do
    test "returns the order_item_extra with given id" do
      order_item_extra = order_item_extra_fixture()
      assert LunchbotData.get_order_item_extra!(order_item_extra.id) == order_item_extra
    end
  end

  describe "#create_order_item_extra/1" do
    test "with valid data creates a order_item_extra" do
      assert {:ok, %OrderItemExtra{} = order_item_extra} =
               LunchbotData.create_order_item_extra(@valid_attrs)

      assert order_item_extra.extra_id == 42
      assert order_item_extra.order_item_id == 42
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_order_item_extra(@invalid_attrs)
    end
  end

  describe "#update_order_item_extra/2" do
    test "with valid data updates the order_item_extra" do
      order_item_extra = order_item_extra_fixture()

      assert {:ok, order_item_extra} =
               LunchbotData.update_order_item_extra(order_item_extra, @update_attrs)

      assert %OrderItemExtra{} = order_item_extra
      assert order_item_extra.extra_id == 43
      assert order_item_extra.order_item_id == 43
    end

    test "with invalid data returns error changeset" do
      order_item_extra = order_item_extra_fixture()

      assert {:error, %Ecto.Changeset{}} =
               LunchbotData.update_order_item_extra(order_item_extra, @invalid_attrs)

      assert order_item_extra == LunchbotData.get_order_item_extra!(order_item_extra.id)
    end
  end

  describe "#delete_order_item_extra/1" do
    test "deletes the order_item_extra" do
      order_item_extra = order_item_extra_fixture()
      assert {:ok, %OrderItemExtra{}} = LunchbotData.delete_order_item_extra(order_item_extra)

      assert_raise Ecto.NoResultsError, fn ->
        LunchbotData.get_order_item_extra!(order_item_extra.id)
      end
    end
  end

  describe "#change_order_item_extra/1" do
    test "returns a order_item_extra changeset" do
      order_item_extra = order_item_extra_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_order_item_extra(order_item_extra)
    end
  end

  def order_item_extra_fixture(attrs \\ %{}) do
    {:ok, order_item_extra} =
      attrs
      |> Enum.into(@valid_attrs)
      |> LunchbotData.create_order_item_extra()

    order_item_extra
  end

  alias Lunchbot.LunchbotData.Extra

  @valid_attrs %{item_id: 42, name: "some name"}
  @update_attrs %{item_id: 43, name: "some updated name"}
  @invalid_attrs %{item_id: nil, name: nil}

  describe "#paginate_extras/1" do
    test "returns paginated list of extras" do
      for _ <- 1..20 do
        extra_fixture()
      end

      {:ok, %{extras: extras} = page} = LunchbotData.paginate_extras(%{})

      assert length(extras) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_extras/0" do
    test "returns all extras" do
      extra = extra_fixture()
      assert LunchbotData.list_extras() == [extra]
    end
  end

  describe "#get_extra!/1" do
    test "returns the extra with given id" do
      extra = extra_fixture()
      assert LunchbotData.get_extra!(extra.id) == extra
    end
  end

  describe "#create_extra/1" do
    test "with valid data creates a extra" do
      assert {:ok, %Extra{} = extra} = LunchbotData.create_extra(@valid_attrs)
      assert extra.item_id == 42
      assert extra.name == "some name"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_extra(@invalid_attrs)
    end
  end

  describe "#update_extra/2" do
    test "with valid data updates the extra" do
      extra = extra_fixture()
      assert {:ok, extra} = LunchbotData.update_extra(extra, @update_attrs)
      assert %Extra{} = extra
      assert extra.item_id == 43
      assert extra.name == "some updated name"
    end

    test "with invalid data returns error changeset" do
      extra = extra_fixture()
      assert {:error, %Ecto.Changeset{}} = LunchbotData.update_extra(extra, @invalid_attrs)
      assert extra == LunchbotData.get_extra!(extra.id)
    end
  end

  describe "#delete_extra/1" do
    test "deletes the extra" do
      extra = extra_fixture()
      assert {:ok, %Extra{}} = LunchbotData.delete_extra(extra)
      assert_raise Ecto.NoResultsError, fn -> LunchbotData.get_extra!(extra.id) end
    end
  end

  describe "#change_extra/1" do
    test "returns a extra changeset" do
      extra = extra_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_extra(extra)
    end
  end

  def extra_fixture(attrs \\ %{}) do
    {:ok, extra} =
      attrs
      |> Enum.into(@valid_attrs)
      |> LunchbotData.create_extra()

    extra
  end

  alias Lunchbot.LunchbotData.ItemExtra

  @valid_attrs %{extra_id: 42, item_id: 42}
  @update_attrs %{extra_id: 43, item_id: 43}
  @invalid_attrs %{extra_id: nil, item_id: nil}

  describe "#paginate_item_extras/1" do
    test "returns paginated list of item_extras" do
      for _ <- 1..20 do
        item_extra_fixture()
      end

      {:ok, %{item_extras: item_extras} = page} = LunchbotData.paginate_item_extras(%{})

      assert length(item_extras) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_item_extras/0" do
    test "returns all item_extras" do
      item_extra = item_extra_fixture()
      assert LunchbotData.list_item_extras() == [item_extra]
    end
  end

  describe "#get_item_extra!/1" do
    test "returns the item_extra with given id" do
      item_extra = item_extra_fixture()
      assert LunchbotData.get_item_extra!(item_extra.id) == item_extra
    end
  end

  describe "#create_item_extra/1" do
    test "with valid data creates a item_extra" do
      assert {:ok, %ItemExtra{} = item_extra} = LunchbotData.create_item_extra(@valid_attrs)
      assert item_extra.extra_id == 42
      assert item_extra.item_id == 42
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_item_extra(@invalid_attrs)
    end
  end

  describe "#update_item_extra/2" do
    test "with valid data updates the item_extra" do
      item_extra = item_extra_fixture()
      assert {:ok, item_extra} = LunchbotData.update_item_extra(item_extra, @update_attrs)
      assert %ItemExtra{} = item_extra
      assert item_extra.extra_id == 43
      assert item_extra.item_id == 43
    end

    test "with invalid data returns error changeset" do
      item_extra = item_extra_fixture()

      assert {:error, %Ecto.Changeset{}} =
               LunchbotData.update_item_extra(item_extra, @invalid_attrs)

      assert item_extra == LunchbotData.get_item_extra!(item_extra.id)
    end
  end

  describe "#delete_item_extra/1" do
    test "deletes the item_extra" do
      item_extra = item_extra_fixture()
      assert {:ok, %ItemExtra{}} = LunchbotData.delete_item_extra(item_extra)
      assert_raise Ecto.NoResultsError, fn -> LunchbotData.get_item_extra!(item_extra.id) end
    end
  end

  describe "#change_item_extra/1" do
    test "returns a item_extra changeset" do
      item_extra = item_extra_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_item_extra(item_extra)
    end
  end

  def item_extra_fixture(attrs \\ %{}) do
    {:ok, item_extra} =
      attrs
      |> Enum.into(@valid_attrs)
      |> LunchbotData.create_item_extra()

    item_extra
  end
end
