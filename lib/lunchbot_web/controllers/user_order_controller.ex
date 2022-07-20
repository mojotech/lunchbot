defmodule LunchbotWeb.UserOrdersController do
  use LunchbotWeb, :controller

  import Ecto.Query

  alias Lunchbot.Repo

  def view(conn, _params) do
    # How are we retrieving the menu_id from our current date?
    # Assuming we can grab this from slackbot.ex somehow in the future
    todays_menu_name = getMenuName(1)
    all_items = getCategoriesAndItems(1)
    all_options = getAllOptions(all_items)

    render(conn, "view.html",
      todays_menu: todays_menu_name,
      all_items: all_items,
      all_options: all_options
    )
  end

  defp getMenuName(menu_id) do
    todays_menu_name_query =
      from m in "menus",
        where: m.id == ^menu_id,
        select: m.name

    Repo.all(todays_menu_name_query)
    |> Enum.at(0)
  end

  defp getCategoriesAndItems(menu_id) do
    todays_menu_id_query =
      from m in "menus",
        where: m.id == ^menu_id,
        select: m.id

    todays_menu_id =
      Repo.all(todays_menu_id_query)
      |> Enum.at(0)

    categories_query =
      from c in "categories",
        where: c.menu_id == ^todays_menu_id,
        select: [c.name, c.id]

    Repo.all(categories_query)
    |> Enum.map(fn [k, v] ->
      {k, Repo.all(from i in "items", where: i.category_id == ^v, select: i.name)}
    end)
    |> Map.new()
  end

  defp getItemId(name) do
    curr_item_id_query =
      from i in "items",
        where: i.name == ^name,
        select: i.id

    Repo.all(curr_item_id_query)
    |> Enum.at(0)
  end

  defp getItemOptionHeadings(itemId) do
    item_option_headings_query =
      from ioh in "item_option_headings",
        where: ioh.item_id == ^itemId,
        select: ioh.option_heading_id

    Repo.all(item_option_headings_query)
  end

  defp optionsFromIOH(options_map, ioh_ids) do
    for ioh_id <- ioh_ids do
      option_heading_query =
        from oh in "option_headings",
          where: oh.id == ^ioh_id,
          select: oh.name

      option_heading =
        Repo.all(option_heading_query)
        |> Enum.at(0)

      curr_options_query =
        from o in "options",
          where: o.option_heading_id == ^ioh_id,
          select: o.name

      curr_options = Repo.all(curr_options_query)

      Map.put(options_map, option_heading, curr_options)
    end
  end

  defp mergeMaps(list) do
    Enum.reduce(list, fn x, y ->
      Map.merge(x, y, fn _k, v1, v2 -> v2 ++ v1 end)
    end)
  end

  defp getAllOptions(all_items) do
    all_items_list =
      for {_k, v} <- all_items do
        for item <- v do
          item
        end
      end
      |> List.flatten()
      |> Enum.map(fn k -> {k, %{}} end)
      |> Map.new()

    for {k, _v} <- all_items_list do
      curr_item_id = getItemId(k)
      item_option_headings_id = getItemOptionHeadings(curr_item_id)

      if(item_option_headings_id != nil) do
        optionsMap = %{}
        options = optionsFromIOH(optionsMap, item_option_headings_id)
        %{k => options}
      else
        %{k => []}
      end
    end
    |> mergeMaps()
  end
end
