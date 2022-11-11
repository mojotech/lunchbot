defmodule Lunchbot.LunchbotDataTest do
  use Lunchbot.DataCase

  alias Lunchbot.LunchbotData

  alias Lunchbot.Accounts

  alias Lunchbot.Accounts.User
  alias Lunchbot.LunchbotDataFixtures

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
      user = Map.replace!(LunchbotDataFixtures.user_fixture(), :password, nil)
      assert Accounts.list_users() == [user]
    end
  end

  describe "#get_user!/1" do
    test "returns the user with given id" do
      user = Map.replace!(LunchbotDataFixtures.user_fixture(), :password, nil)
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
      user = LunchbotDataFixtures.user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.name == "some updated name"
      assert user.email == "some updated email"
      assert user.role == "some updated role"
    end

    test "with invalid data returns error changeset" do
      user = Map.replace!(LunchbotDataFixtures.user_fixture(), :password, nil)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end
  end

  describe "#delete_user/1" do
    test "deletes the user" do
      user = LunchbotDataFixtures.user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end
  end

  describe "#change_user/1" do
    test "returns a user changeset" do
      user = LunchbotDataFixtures.user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  alias Lunchbot.LunchbotData.Office

  @valid_attrs %{name: "some name", timezone: "some timezone"}
  @update_attrs %{name: "some updated name", timezone: "some updated timezone"}
  @invalid_attrs %{name: nil, timezone: nil}

  describe "#paginate_offices/1" do
    test "returns paginated list of offices" do
      for _ <- 1..20 do
        LunchbotDataFixtures.office_fixture()
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
      office = LunchbotDataFixtures.office_fixture()
      assert LunchbotData.list_offices() == [office]
    end
  end

  describe "#get_office!/1" do
    test "returns the office with given id" do
      office = LunchbotDataFixtures.office_fixture()
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
      office = LunchbotDataFixtures.office_fixture()
      assert {:ok, office} = LunchbotData.update_office(office, @update_attrs)
      assert %Office{} = office
      assert office.name == "some updated name"
      assert office.timezone == "some updated timezone"
    end

    test "with invalid data returns error changeset" do
      office = LunchbotDataFixtures.office_fixture()
      assert {:error, %Ecto.Changeset{}} = LunchbotData.update_office(office, @invalid_attrs)
      assert office == LunchbotData.get_office!(office.id)
    end
  end

  describe "#delete_office/1" do
    test "deletes the office" do
      office = LunchbotDataFixtures.office_fixture()
      assert {:ok, %Office{}} = LunchbotData.delete_office(office)
      assert_raise Ecto.NoResultsError, fn -> LunchbotData.get_office!(office.id) end
    end
  end

  describe "#change_office/1" do
    test "returns a office changeset" do
      office = LunchbotDataFixtures.office_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_office(office)
    end
  end

  alias Lunchbot.LunchbotData.Menu

  @valid_attrs %{name: "some name", office_id: 42}
  @update_attrs %{name: "some updated name", office_id: 43}
  @invalid_attrs %{name: nil, office_id: nil}

  describe "#paginate_menus/1" do
    test "returns paginated list of menus" do
      for _ <- 1..20 do
        LunchbotDataFixtures.menu_fixture()
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
      menu = LunchbotDataFixtures.menu_fixture()
      assert LunchbotData.list_menus() == [menu]
    end
  end

  describe "#get_menu!/1" do
    test "returns the menu with given id" do
      menu = LunchbotDataFixtures.menu_fixture()
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
      menu = LunchbotDataFixtures.menu_fixture()
      assert {:ok, menu} = LunchbotData.update_menu(menu, @update_attrs)
      assert %Menu{} = menu
      assert menu.name == "some updated name"
      assert menu.office_id == 43
    end

    test "with invalid data returns error changeset" do
      menu = LunchbotDataFixtures.menu_fixture()
      assert {:error, %Ecto.Changeset{}} = LunchbotData.update_menu(menu, @invalid_attrs)
      assert menu == LunchbotData.get_menu!(menu.id)
    end
  end

  describe "#delete_menu/1" do
    test "deletes the menu" do
      menu = LunchbotDataFixtures.menu_fixture()
      assert {:ok, %Menu{}} = LunchbotData.delete_menu(menu)
      assert_raise Ecto.NoResultsError, fn -> LunchbotData.get_menu!(menu.id) end
    end
  end

  describe "#change_menu/1" do
    test "returns a menu changeset" do
      menu = LunchbotDataFixtures.menu_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_menu(menu)
    end
  end

  alias Lunchbot.LunchbotData.OfficeLunchOrder

  @valid_attrs %{day: ~D[2022-07-07], office_id: 42, menu_id: 42}
  @update_attrs %{day: ~D[2022-07-08], office_id: 43, menu_id: 43}
  @invalid_attrs %{day: nil, office_id: nil, menu_id: nil}

  describe "#paginate_office_lunch_orders/1" do
    test "returns paginated list of office_lunch_orders" do
      for _ <- 1..20 do
        LunchbotDataFixtures.office_lunch_order_fixture()
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
      office_lunch_order = LunchbotDataFixtures.office_lunch_order_fixture()
      assert LunchbotData.list_office_lunch_orders() == [office_lunch_order]
    end
  end

  describe "#get_office_lunch_order!/1" do
    test "returns the office_lunch_order with given id" do
      office_lunch_order = LunchbotDataFixtures.office_lunch_order_fixture()
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
      office_lunch_order = LunchbotDataFixtures.office_lunch_order_fixture()

      assert {:ok, office_lunch_order} =
               LunchbotData.update_office_lunch_order(office_lunch_order, @update_attrs)

      assert %OfficeLunchOrder{} = office_lunch_order
      assert office_lunch_order.day == ~D[2022-07-08]
      assert office_lunch_order.office_id == 43
    end

    test "with invalid data returns error changeset" do
      office_lunch_order = LunchbotDataFixtures.office_lunch_order_fixture()

      assert {:error, %Ecto.Changeset{}} =
               LunchbotData.update_office_lunch_order(office_lunch_order, @invalid_attrs)

      assert office_lunch_order == LunchbotData.get_office_lunch_order!(office_lunch_order.id)
    end
  end

  describe "#delete_office_lunch_order/1" do
    test "deletes the office_lunch_order" do
      office_lunch_order = LunchbotDataFixtures.office_lunch_order_fixture()

      assert {:ok, %OfficeLunchOrder{}} =
               LunchbotData.delete_office_lunch_order(office_lunch_order)

      assert_raise Ecto.NoResultsError, fn ->
        LunchbotData.get_office_lunch_order!(office_lunch_order.id)
      end
    end
  end

  describe "#change_office_lunch_order/1" do
    test "returns a office_lunch_order changeset" do
      office_lunch_order = LunchbotDataFixtures.office_lunch_order_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_office_lunch_order(office_lunch_order)
    end
  end

  alias Lunchbot.LunchbotData.Order

  @valid_attrs %{office_lunch_order_id: 42, menu_id: 42, user_id: 42}
  @update_attrs %{office_lunch_order_id: 43, menu_id: 43, user_id: 43}
  @invalid_attrs %{office_lunch_order_id: nil, menu_id: nil, user_id: nil}

  describe "#paginate_orders/1" do
    test "returns paginated list of orders" do
      for _ <- 1..20 do
        LunchbotDataFixtures.order_fixture()
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
      order = LunchbotDataFixtures.order_fixture()
      assert LunchbotData.list_orders() == [order]
    end
  end

  describe "#get_order!/1" do
    test "returns the order with given id" do
      order = LunchbotDataFixtures.order_fixture()
      assert LunchbotData.get_order!(order.id) == order
    end
  end

  describe "#create_order/1" do
    test "with valid data creates a order" do
      office_lunch_order = LunchbotDataFixtures.office_lunch_order_fixture()
      menu = LunchbotDataFixtures.menu_fixture()
      user = LunchbotDataFixtures.user_fixture()

      params = %{
        office_lunch_order_id: office_lunch_order.id,
        menu_id: menu.id,
        user_id: user.id
      }

      assert {:ok, %Order{} = order} = LunchbotData.create_order(params)
      assert order.office_lunch_order_id == office_lunch_order.id
      assert order.menu_id == menu.id
      assert order.user_id == user.id
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_order(@invalid_attrs)
    end
  end

  describe "#update_order/2" do
    test "with valid data updates the order" do
      order = LunchbotDataFixtures.order_fixture()
      office_lunch_order = LunchbotDataFixtures.office_lunch_order_fixture()
      menu = LunchbotDataFixtures.menu_fixture()
      user = LunchbotDataFixtures.user_fixture()

      params = %{
        menu_id: menu.id,
        office_lunch_order_id: office_lunch_order.id,
        user_id: user.id
      }

      assert {:ok, order} = LunchbotData.update_order(order, params)
      assert %Order{} = order
    end

    test "with invalid data returns error changeset" do
      order = LunchbotDataFixtures.order_fixture()
      assert {:error, %Ecto.Changeset{}} = LunchbotData.update_order(order, @invalid_attrs)
      assert order == LunchbotData.get_order!(order.id)
    end
  end

  describe "#delete_order/1" do
    test "deletes the order" do
      order = LunchbotDataFixtures.order_fixture()
      assert {:ok, %Order{}} = LunchbotData.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> LunchbotData.get_order!(order.id) end
    end
  end

  describe "#change_order/1" do
    test "returns a order changeset" do
      order = LunchbotDataFixtures.order_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_order(order)
    end
  end

  alias Lunchbot.LunchbotData.Category

  @valid_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "#paginate_categories/1" do
    test "returns paginated list of categories" do
      for _ <- 1..20 do
        LunchbotDataFixtures.category_fixture()
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
      category = LunchbotDataFixtures.category_fixture()
      assert LunchbotData.list_categories() == [category]
    end
  end

  describe "#get_category!/1" do
    test "returns the category with given id" do
      category = LunchbotDataFixtures.category_fixture()
      assert LunchbotData.get_category!(category.id) == category
    end
  end

  describe "#create_category/1" do
    test "with valid data creates a category" do
      assert {:ok, %Category{} = category} = LunchbotData.create_category(@valid_attrs)
      assert category.name == "some name"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_category(@invalid_attrs)
    end
  end

  describe "#update_category/2" do
    test "with valid data updates the category" do
      category = LunchbotDataFixtures.category_fixture()
      assert {:ok, category} = LunchbotData.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.name == "some updated name"
    end

    test "with invalid data returns error changeset" do
      category = LunchbotDataFixtures.category_fixture()
      assert {:error, %Ecto.Changeset{}} = LunchbotData.update_category(category, @invalid_attrs)
      assert category == LunchbotData.get_category!(category.id)
    end
  end

  describe "#delete_category/1" do
    test "deletes the category" do
      category = LunchbotDataFixtures.category_fixture()
      assert {:ok, %Category{}} = LunchbotData.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> LunchbotData.get_category!(category.id) end
    end
  end

  describe "#change_category/1" do
    test "returns a category changeset" do
      category = LunchbotDataFixtures.category_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_category(category)
    end
  end

  alias Lunchbot.LunchbotData.OrderItem

  @valid_attrs %{item_id: 42, order_id: 42}
  @update_attrs %{item_id: 43, order_id: 43}
  @invalid_attrs %{item_id: nil, order_id: nil}

  describe "#paginate_order_items/1" do
    test "returns paginated list of order_items" do
      for _ <- 1..20 do
        LunchbotDataFixtures.order_item_fixture()
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
      item = LunchbotDataFixtures.item_fixture()
      order = LunchbotDataFixtures.order_fixture()

      order_item =
        LunchbotDataFixtures.order_item_fixture(%{item_id: item.id, order_id: order.id})

      assert LunchbotData.list_order_items() == [order_item]
    end
  end

  describe "#get_order_item!/1" do
    test "returns the order_item with given id" do
      order_item = LunchbotDataFixtures.order_item_fixture()
      assert LunchbotData.get_order_item!(order_item.id) == order_item
    end
  end

  describe "#create_order_item/1" do
    test "with valid data creates a order_item" do
      order = LunchbotDataFixtures.order_fixture()
      item = LunchbotDataFixtures.item_fixture()
      params = %{order_id: order.id, item_id: item.id}

      assert {:ok, %OrderItem{} = order_item} = LunchbotData.create_order_item(params)
      assert order_item.item_id == item.id
      assert order_item.order_id == order.id
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_order_item(@invalid_attrs)
    end
  end

  describe "#update_order_item/2" do
    test "with valid data updates the order_item" do
      order_item = LunchbotDataFixtures.order_item_fixture()
      order = LunchbotDataFixtures.order_fixture()
      item = LunchbotDataFixtures.item_fixture()
      params = %{order_id: order.id, item_id: item.id}

      assert {:ok, order_item} = LunchbotData.update_order_item(order_item, params)
      assert %OrderItem{} = order_item
      assert order_item.item_id == item.id
      assert order_item.order_id == order.id
    end

    test "with invalid data returns error changeset" do
      order_item = LunchbotDataFixtures.order_item_fixture()

      assert {:error, %Ecto.Changeset{}} =
               LunchbotData.update_order_item(order_item, @invalid_attrs)

      assert order_item == LunchbotData.get_order_item!(order_item.id)
    end
  end

  describe "#delete_order_item/1" do
    test "deletes the order_item" do
      order_item = LunchbotDataFixtures.order_item_fixture()
      assert {:ok, %OrderItem{}} = LunchbotData.delete_order_item(order_item)
      assert_raise Ecto.NoResultsError, fn -> LunchbotData.get_order_item!(order_item.id) end
    end
  end

  describe "#change_order_item/1" do
    test "returns a order_item changeset" do
      order_item = LunchbotDataFixtures.order_item_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_order_item(order_item)
    end
  end

  alias Lunchbot.LunchbotData.Item

  @valid_attrs %{
    category_id: 42,
    deleted: true,
    description: "some description",
    image_url: "some image_url",
    name: "some name",
    price: 10
  }
  @update_attrs %{
    category_id: 43,
    deleted: false,
    description: "some updated description",
    image_url: "some updated image_url",
    name: "some updated name",
    price: 11
  }
  @invalid_attrs %{
    category_id: nil,
    deleted: nil,
    description: nil,
    image_url: nil,
    name: nil,
    price: nil
  }

  describe "#paginate_items/1" do
    test "returns paginated list of items" do
      for _ <- 1..20 do
        LunchbotDataFixtures.item_fixture()
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
      item = LunchbotDataFixtures.item_fixture()
      assert LunchbotData.list_items() == [item]
    end
  end

  describe "#get_item!/1" do
    test "returns the item with given id" do
      item = LunchbotDataFixtures.item_fixture()
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
      assert item.description == "some description"
      assert item.price == 10
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_item(@invalid_attrs)
    end
  end

  describe "#update_item/2" do
    test "with valid data updates the item" do
      item = LunchbotDataFixtures.item_fixture()
      assert {:ok, item} = LunchbotData.update_item(item, @update_attrs)
      assert %Item{} = item
      assert item.category_id == 43
      assert item.deleted == false
      assert item.image_url == "some updated image_url"
      assert item.name == "some updated name"
      assert item.description == "some updated description"
      assert item.price == 11
    end

    test "with invalid data returns error changeset" do
      item = LunchbotDataFixtures.item_fixture()
      assert {:error, %Ecto.Changeset{}} = LunchbotData.update_item(item, @invalid_attrs)
      assert item == LunchbotData.get_item!(item.id)
    end
  end

  describe "#delete_item/1" do
    test "deletes the item" do
      item = LunchbotDataFixtures.item_fixture()
      assert {:ok, %Item{}} = LunchbotData.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> LunchbotData.get_item!(item.id) end
    end
  end

  describe "#change_item/1" do
    test "returns a item changeset" do
      item = LunchbotDataFixtures.item_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_item(item)
    end
  end

  alias Lunchbot.LunchbotData.ItemOptionHeadings

  @valid_attrs %{item_id: 42, option_heading_id: 42}
  @update_attrs %{item_id: 43, option_heading_id: 43}
  @invalid_attrs %{item_id: nil, option_heading_id: nil}

  describe "#paginate_item_option_headings/1" do
    test "returns paginated list of item_option_headings" do
      for _ <- 1..20 do
        LunchbotDataFixtures.item_option_headings_fixture()
      end

      {:ok, %{item_option_headings: item_option_headings} = page} =
        LunchbotData.paginate_item_option_headings(%{})

      assert length(item_option_headings) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_item_option_headings/0" do
    test "returns all item_option_headings" do
      item_option_headings = LunchbotDataFixtures.item_option_headings_fixture()
      assert LunchbotData.list_item_option_headings() == [item_option_headings]
    end
  end

  describe "#get_item_option_headings!/1" do
    test "returns the item_option_headings with given id" do
      item_option_headings = LunchbotDataFixtures.item_option_headings_fixture()

      assert LunchbotData.get_item_option_headings!(item_option_headings.id) ==
               item_option_headings
    end
  end

  describe "#create_item_option_headings/1" do
    test "with valid data creates a item_option_headings" do
      assert {:ok, %ItemOptionHeadings{} = item_option_headings} =
               LunchbotData.create_item_option_headings(@valid_attrs)

      assert item_option_headings.item_id == 42
      assert item_option_headings.option_heading_id == 42
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               LunchbotData.create_item_option_headings(@invalid_attrs)
    end
  end

  describe "#update_item_option_headings/2" do
    test "with valid data updates the item_option_headings" do
      item_option_headings = LunchbotDataFixtures.item_option_headings_fixture()

      assert {:ok, item_option_headings} =
               LunchbotData.update_item_option_headings(item_option_headings, @update_attrs)

      assert %ItemOptionHeadings{} = item_option_headings
      assert item_option_headings.item_id == 43
      assert item_option_headings.option_heading_id == 43
    end

    test "with invalid data returns error changeset" do
      item_option_headings = LunchbotDataFixtures.item_option_headings_fixture()

      assert {:error, %Ecto.Changeset{}} =
               LunchbotData.update_item_option_headings(item_option_headings, @invalid_attrs)

      assert item_option_headings ==
               LunchbotData.get_item_option_headings!(item_option_headings.id)
    end
  end

  describe "#delete_item_option_headings/1" do
    test "deletes the item_option_headings" do
      item_option_headings = LunchbotDataFixtures.item_option_headings_fixture()

      assert {:ok, %ItemOptionHeadings{}} =
               LunchbotData.delete_item_option_headings(item_option_headings)

      assert_raise Ecto.NoResultsError, fn ->
        LunchbotData.get_item_option_headings!(item_option_headings.id)
      end
    end
  end

  describe "#change_item_option_headings/1" do
    test "returns a item_option_headings changeset" do
      item_option_headings = LunchbotDataFixtures.item_option_headings_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_item_option_headings(item_option_headings)
    end
  end

  alias Lunchbot.LunchbotData.OptionHeading

  @valid_attrs %{name: "some name", priority: 42}
  @update_attrs %{name: "some updated name", priority: 43}
  @invalid_attrs %{name: nil, priority: nil}

  describe "#paginate_option_headings/1" do
    test "returns paginated list of option_headings" do
      for _ <- 1..20 do
        LunchbotDataFixtures.option_headings_fixture()
      end

      {:ok, %{option_headings: option_headings} = page} =
        LunchbotData.paginate_option_headings(%{})

      assert length(option_headings) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_option_headings/0" do
    test "returns all option_headings" do
      option_headings = LunchbotDataFixtures.option_headings_fixture()
      assert LunchbotData.list_option_headings() == [option_headings]
    end
  end

  describe "#get_option_headings!/1" do
    test "returns the option_headings with given id" do
      option_headings = LunchbotDataFixtures.option_headings_fixture()
      assert LunchbotData.get_option_headings!(option_headings.id) == option_headings
    end
  end

  describe "#create_option_headings/1" do
    test "with valid data creates a option_headings" do
      assert {:ok, %OptionHeading{} = option_headings} =
               LunchbotData.create_option_headings(@valid_attrs)

      assert option_headings.name == "some name"
      assert option_headings.priority == 42
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_option_headings(@invalid_attrs)
    end
  end

  describe "#update_option_headings/2" do
    test "with valid data updates the option_headings" do
      option_headings = LunchbotDataFixtures.option_headings_fixture()

      assert {:ok, option_headings} =
               LunchbotData.update_option_headings(option_headings, @update_attrs)

      assert %OptionHeading{} = option_headings
      assert option_headings.name == "some updated name"
      assert option_headings.priority == 43
    end

    test "with invalid data returns error changeset" do
      option_headings = LunchbotDataFixtures.option_headings_fixture()

      assert {:error, %Ecto.Changeset{}} =
               LunchbotData.update_option_headings(option_headings, @invalid_attrs)

      assert option_headings == LunchbotData.get_option_headings!(option_headings.id)
    end
  end

  describe "#delete_option_headings/1" do
    test "deletes the option_headings" do
      option_headings = LunchbotDataFixtures.option_headings_fixture()
      assert {:ok, %OptionHeading{}} = LunchbotData.delete_option_headings(option_headings)

      assert_raise Ecto.NoResultsError, fn ->
        LunchbotData.get_option_headings!(option_headings.id)
      end
    end
  end

  describe "#change_option_headings/1" do
    test "returns a option_headings changeset" do
      option_headings = LunchbotDataFixtures.option_headings_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_option_headings(option_headings)
    end
  end

  alias Lunchbot.LunchbotData.OrderItemOptions

  @valid_attrs %{option_id: 42, order_item_id: 42}
  @update_attrs %{option_id: 43, order_item_id: 43}
  @invalid_attrs %{option_id: nil, order_item_id: nil}

  describe "#paginate_order_item_options/1" do
    test "returns paginated list of order_item_options" do
      for _ <- 1..20 do
        LunchbotDataFixtures.order_item_options_fixture()
      end

      {:ok, %{order_item_options: order_item_options} = page} =
        LunchbotData.paginate_order_item_options(%{})

      assert length(order_item_options) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_order_item_options/0" do
    test "returns all order_item_options" do
      order_item_options = LunchbotDataFixtures.order_item_options_fixture()
      assert LunchbotData.list_order_item_options() == [order_item_options]
    end
  end

  describe "#get_order_item_options!/1" do
    test "returns the order_item_options with given id" do
      order_item_options = LunchbotDataFixtures.order_item_options_fixture()
      assert LunchbotData.get_order_item_options!(order_item_options.id) == order_item_options
    end
  end

  describe "#create_order_item_options/1" do
    test "with valid data creates a order_item_options" do
      option = LunchbotDataFixtures.options_fixture()
      order_item = LunchbotDataFixtures.order_item_fixture()
      params = %{option_id: option.id, order_item_id: order_item.id}

      assert {:ok, %OrderItemOptions{} = order_item_options} =
               LunchbotData.create_order_item_options(params)

      assert order_item_options.option_id == option.id
      assert order_item_options.order_item_id == order_item.id
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_order_item_options(@invalid_attrs)
    end
  end

  describe "#update_order_item_options/2" do
    test "with valid data updates the order_item_options" do
      order_item_options = LunchbotDataFixtures.order_item_options_fixture()
      option = LunchbotDataFixtures.options_fixture()
      order_item = LunchbotDataFixtures.order_item_fixture()
      params = %{option_id: option.id, order_item_id: order_item.id}

      assert {:ok, order_item_options} =
               LunchbotData.update_order_item_options(order_item_options, params)

      assert %OrderItemOptions{} = order_item_options
      assert order_item_options.option_id == option.id
      assert order_item_options.order_item_id == order_item.id
    end

    test "with invalid data returns error changeset" do
      order_item_options = LunchbotDataFixtures.order_item_options_fixture()

      assert {:error, %Ecto.Changeset{}} =
               LunchbotData.update_order_item_options(order_item_options, @invalid_attrs)

      assert order_item_options == LunchbotData.get_order_item_options!(order_item_options.id)
    end
  end

  describe "#delete_order_item_options/1" do
    test "deletes the order_item_options" do
      # create option
      # create order item

      option = LunchbotDataFixtures.options_fixture()
      order_item = LunchbotDataFixtures.order_item_fixture()

      order_item_options =
        LunchbotDataFixtures.order_item_options_fixture(%{
          option_id: option.id,
          order_item_id: order_item.id
        })

      assert {:ok, %OrderItemOptions{}} =
               LunchbotData.delete_order_item_options(order_item_options)

      assert_raise Ecto.NoResultsError, fn ->
        LunchbotData.get_order_item_options!(order_item_options.id)
      end
    end
  end

  describe "#change_order_item_options/1" do
    test "returns a order_item_options changeset" do
      option = LunchbotDataFixtures.options_fixture()
      order_item = LunchbotDataFixtures.order_item_fixture()

      order_item_options =
        LunchbotDataFixtures.order_item_options_fixture(%{
          option_id: option.id,
          order_item_id: order_item.id
        })

      assert %Ecto.Changeset{} = LunchbotData.change_order_item_options(order_item_options)
    end
  end

  alias Lunchbot.LunchbotData.Options

  @valid_attrs %{
    extra_price: 42,
    extras: true,
    is_required: true,
    name: "some name",
    option_heading_id: 42,
    preselected: true,
    price: 42
  }
  @update_attrs %{
    extra_price: 43,
    extras: false,
    is_required: false,
    name: "some updated name",
    option_heading_id: 43,
    preselected: false,
    price: 43
  }
  @invalid_attrs %{
    extra_price: nil,
    extras: nil,
    is_required: nil,
    name: nil,
    option_heading_id: nil,
    preselected: nil,
    price: nil
  }

  describe "#paginate_options/1" do
    test "returns paginated list of options" do
      for _ <- 1..20 do
        LunchbotDataFixtures.options_fixture()
      end

      {:ok, %{options: options} = page} = LunchbotData.paginate_options(%{})

      assert length(options) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_options/0" do
    test "returns all options" do
      options = LunchbotDataFixtures.options_fixture()
      assert LunchbotData.list_options() == [options]
    end
  end

  describe "#get_options!/1" do
    test "returns the options with given id" do
      options = LunchbotDataFixtures.options_fixture()
      assert LunchbotData.get_options!(options.id) == options
    end
  end

  describe "#create_options/1" do
    test "with valid data creates a options" do
      assert {:ok, %Options{} = options} = LunchbotData.create_options(@valid_attrs)
      assert options.extra_price == 42
      assert options.extras == true
      assert options.is_required == true
      assert options.name == "some name"
      assert options.option_heading_id == 42
      assert options.preselected == true
      assert options.price == 42
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_options(@invalid_attrs)
    end
  end

  describe "#update_options/2" do
    test "with valid data updates the options" do
      options = LunchbotDataFixtures.options_fixture()
      assert {:ok, options} = LunchbotData.update_options(options, @update_attrs)
      assert %Options{} = options
      assert options.extra_price == 43
      assert options.extras == false
      assert options.is_required == false
      assert options.name == "some updated name"
      assert options.option_heading_id == 43
      assert options.preselected == false
      assert options.price == 43
    end

    test "with invalid data returns error changeset" do
      options = LunchbotDataFixtures.options_fixture()
      assert {:error, %Ecto.Changeset{}} = LunchbotData.update_options(options, @invalid_attrs)
      assert options == LunchbotData.get_options!(options.id)
    end
  end

  describe "#delete_options/1" do
    test "deletes the options" do
      options = LunchbotDataFixtures.options_fixture()
      assert {:ok, %Options{}} = LunchbotData.delete_options(options)
      assert_raise Ecto.NoResultsError, fn -> LunchbotData.get_options!(options.id) end
    end
  end

  describe "#change_options/1" do
    test "returns a options changeset" do
      options = LunchbotDataFixtures.options_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_options(options)
    end
  end

  alias Lunchbot.LunchbotData.MenuCategories

  @valid_attrs %{category_id: 42, menu_id: 42}
  @update_attrs %{category_id: 43, menu_id: 43}
  @invalid_attrs %{category_id: nil, menu_id: nil}

  describe "#paginate_menu_categories/1" do
    test "returns paginated list of menu_categories" do
      for _ <- 1..20 do
        LunchbotDataFixtures.menu_categories_fixture()
      end

      {:ok, %{menu_categories: menu_categories} = page} =
        LunchbotData.paginate_menu_categories(%{})

      assert length(menu_categories) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end
  end

  describe "#list_menu_categories/0" do
    test "returns all menu_categories" do
      menu_categories = LunchbotDataFixtures.menu_categories_fixture()
      assert LunchbotData.list_menu_categories() == [menu_categories]
    end
  end

  describe "#get_menu_categories!/1" do
    test "returns the menu_categories with given id" do
      menu_categories = LunchbotDataFixtures.menu_categories_fixture()
      assert LunchbotData.get_menu_categories!(menu_categories.id) == menu_categories
    end
  end

  describe "#create_menu_categories/1" do
    test "with valid data creates a menu_categories" do
      assert {:ok, %MenuCategories{} = menu_categories} =
               LunchbotData.create_menu_categories(@valid_attrs)

      assert menu_categories.category_id == 42
      assert menu_categories.menu_id == 42
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LunchbotData.create_menu_categories(@invalid_attrs)
    end
  end

  describe "#update_menu_categories/2" do
    test "with valid data updates the menu_categories" do
      menu_categories = LunchbotDataFixtures.menu_categories_fixture()

      assert {:ok, menu_categories} =
               LunchbotData.update_menu_categories(menu_categories, @update_attrs)

      assert %MenuCategories{} = menu_categories
      assert menu_categories.category_id == 43
      assert menu_categories.menu_id == 43
    end

    test "with invalid data returns error changeset" do
      menu_categories = LunchbotDataFixtures.menu_categories_fixture()

      assert {:error, %Ecto.Changeset{}} =
               LunchbotData.update_menu_categories(menu_categories, @invalid_attrs)

      assert menu_categories == LunchbotData.get_menu_categories!(menu_categories.id)
    end
  end

  describe "#delete_menu_categories/1" do
    test "deletes the menu_categories" do
      menu_categories = LunchbotDataFixtures.menu_categories_fixture()
      assert {:ok, %MenuCategories{}} = LunchbotData.delete_menu_categories(menu_categories)

      assert_raise Ecto.NoResultsError, fn ->
        LunchbotData.get_menu_categories!(menu_categories.id)
      end
    end
  end

  describe "#change_menu_categories/1" do
    test "returns a menu_categories changeset" do
      menu_categories = LunchbotDataFixtures.menu_categories_fixture()
      assert %Ecto.Changeset{} = LunchbotData.change_menu_categories(menu_categories)
    end
  end
end
