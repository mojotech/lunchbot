# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Lunchbot.Repo.insert!(%Lunchbot.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Lunchbot.LunchbotData
alias Lunchbot.LunchbotData.Menu
alias Lunchbot.LunchbotData.Category
alias Lunchbot.LunchbotData.MenuCategories
alias Lunchbot.LunchbotData.Item
alias Lunchbot.LunchbotData.OptionHeading
alias Lunchbot.LunchbotData.Options
alias Lunchbot.LunchbotData.ItemOptionHeadings

LunchbotData.create_office(%{
  name: "Providence",
  timezone: "EDT"
})

[
  "Burrito Bowl",
  "Kebob and Curry",
  "Livi's Pockets",
  "Ocean State Sandwich",
  "PF Chang's",
  "Saladworks",
  "Sandwich Hut",
  "Sicilia's",
  "Sonia's"
]
|> Enum.each(fn name -> Lunchbot.Repo.insert!(%Menu{name: name, office_id: 1}) end)

[
  %{name: "Bowl"},
  %{name: "Burrito"},
  %{name: "Vegan / Gluten friendly Dishes w/rice"},
  %{name: "Vegetarian / Gluten friendly Dishes w/rice"},
  %{name: "Chicken Dishes w/rice"},
  %{name: "Salad"},
  %{name: "Sandwich"},
  %{name: "Meals with rice"},
  %{name: "Noodle dishes"},
  %{name: "Salad / bowl base"},
  %{name: "Included toppings"},
  %{name: "Cold Sandwich"},
  %{name: "Hot Sandwich"},
  %{name: "Stuffed Pizza"},
  %{name: "Regular/Thin Crust Pizza"}
]
|> Enum.each(fn ctg -> Lunchbot.Repo.insert!(%Category{name: ctg.name}) end)

category_menus = [
  %{name: "Burrito Bowl", categories: [%{name: "Bowl"}, %{name: "Burrito"}]},
  %{
    name: "Kebob and Curry",
    categories: [
      %{name: "Vegan / Gluten friendly Dishes w/rice"},
      %{name: "Vegetarian / Gluten friendly Dishes w/rice"},
      %{name: "Chicken Dishes w/rice"}
    ]
  },
  %{name: "Livi's Pockets", categories: [%{name: "Salad"}, %{name: "Sandwich"}]},
  %{name: "Ocean State Sandwich", categories: [%{name: "Salad"}, %{name: "Sandwich"}]},
  %{name: "PF Chang's", categories: [%{name: "Meals with rice"}, %{name: "Noodle dishes"}]},
  %{name: "Saladworks", categories: [%{name: "Salad / bowl base"}, %{name: "Included toppings"}]},
  %{name: "Sandwich Hut", categories: [%{name: "Cold Sandwich"}, %{name: "Hot Sandwich"}]},
  %{
    name: "Sicilia's",
    categories: [
      %{name: "Salad"},
      %{name: "Sandwich"},
      %{name: "Stuffed Pizza"},
      %{name: "Regular/Thin Crust Pizza"}
    ]
  },
  %{name: "Sonia's", categories: [%{name: "Bowl"}, %{name: "Salad"}, %{name: "Sandwich"}]}
]

Enum.each(category_menus, fn menu ->
  restaurant = Lunchbot.Repo.get_by!(Menu, name: "#{menu.name}")

  Enum.each(menu.categories, fn ctg ->
    category = Lunchbot.Repo.get_by!(Category, name: "#{ctg.name}")
    Lunchbot.Repo.insert!(%MenuCategories{menu_id: restaurant.id, category_id: category.id})
  end)
end)

category_items = [
  %{name: "Bowl", items: [%{name: "Bowl", description: ""}]},
  %{name: "Burrito", items: [%{name: "Burrito", description: ""}]},
  %{
    name: "Vegan / Gluten friendly Dishes w/rice",
    items: [
      %{name: "TOFU SAAG", description: "FINELY CHOPPED SPINACH, GINGER, GARLIC"},
      %{name: "ALOO GOBHI", description: "POTATO, CAULIFLOWER, GINGER, ONION"},
      %{name: "CHANA MASALA", description: "CHICKPEAS, ONION, GINGER, GARLIC"},
      %{name: "BAINGAN BHARTA", description: "SMOKED EGGPLANT, TOMATO"},
      %{name: "KATHAL & POTATO MASALA", description: "JACKFRUIT, GINGER, GARLIC"},
      %{name: "TOFU MANGO CURRY", description: "FRESH VEGETABLES & STEAMED TOFU"}
    ]
  },
  %{
    name: "Vegetarian / Gluten friendly Dishes w/rice",
    items: [
      %{name: "TOFU MASALA", description: "CREAMY TOMATO SAUCE"},
      %{
        name: "EGG & POTATO CURRY",
        description: "RED ONION, TOMATOES, GINGER & GARLIC"
      },
      %{
        name: "PANEER (cheese) & PEPPER MAKHANI",
        description: "CREAMY, TOMATO MASALA"
      },
      %{name: "MALAI KOFTA", description: "VEGETABLE CROQUETTES, CASHEWS & RAISINS"},
      %{name: "PANEER MUSHROOM KORMA", description: "MUGHLAI SPICES & CASHEW PASTE"},
      %{name: "MADRAS PANEER", description: "COCONUT, TOMATO, TAMARIND"},
      %{name: "SAAG PANEER", description: "FINELY CHOPPED SPINACH, PANEER CHEESE"},
      %{name: "VEGETABLE TIKKA MASALA", description: "CREAMY TOMATO MASALA"},
      %{name: "PANEER TIKKA MASALA", description: "CREAMY, TOMATO MASALA"},
      %{
        name: "CHICKPEA POUTINE",
        description:
          "(no rice) Masala fries topped with chickpeas, scrambled tofu, and a creamy coconut masala sauce"
      }
    ]
  },
  %{
    name: "Chicken Dishes w/rice",
    items: [
      %{name: "CHICKEN TIKKA MASALA", description: "CREAMY, TOMATO MASALA"},
      %{name: "CHICKEN SAAG", description: "FINELY CHOPPED SPINACH, GINGER, GARLIC"},
      %{name: "CHICKEN MUSHROOM KORMA", description: "NUTTY, CREAMY (contains nuts)"},
      %{
        name: "CHICKEN & POTATO VINDALOO",
        description: "RED CHILI PASTE, VINEGAR (spicy)"
      },
      %{name: "MANGO CHICKEN", description: "ASSORTED VEGETABLES, CILANTRO"},
      %{name: "MADRAS CHICKEN", description: "COCONUT, TOMATO, TAMARIND"},
      %{name: "CHICKEN KADHAI", description: "ONIONS, PEPPERS"},
      %{name: "CHICKEN CURRY", description: "ONION PASTE, GINGER, GARLIC"},
      %{name: "CHICKEN TIKKA POUTINE", description: ""}
    ]
  },
  %{
    name: "Salad",
    items: [
      %{name: "GARDEN", description: ""},
      %{name: "GREEK", description: ""},
      %{name: "CAESAR", description: ""}
    ]
  },
  %{
    name: "Sandwich",
    items: [
      %{
        name: "THE WORKS",
        description:
          "5 Falafel, Hummus, Tabouli, Pickles, Israeli Salad, Lettuce, Tomatoes & Tahini Dressing"
      },
      %{
        name: "CRAZY VEGGIE",
        description:
          "Lettuce, Tomatoes, Carrots, Green Peppers, Onions, Roasted Red Peppers, Cucumbers, Feta Cheese, Hummus & Balsamic Vinaigrette"
      },
      %{
        name: "LIVI'S POCKET",
        description:
          "lightly Breaded Eggplant, Fresh Mozzarella, Roasted Red Peppers, Lettuce & Balsamic Vinaigrette"
      },
      %{name: "MJEDRA", description: "(lentil,rice,onion) WRAP - with feta"},
      %{name: "MJEDRA", description: "(lentil,rice,onion) WRAP - NO feta"},
      %{
        name: "CURRY CHICKEN",
        description: "Curry Chicken Salad, Lettuce & Tomatoes"
      },
      %{
        name: "CHICKEN & FALAFEL",
        description:
          "2 Grilled Chicken, 3 Falafel, Lettuce, Tomatoes, Hummus, Tabouli Salad & Tahini Dressing"
      },
      %{
        name: "Chicken Club wrap",
        description: "Grilled Chicken, Lettuce, Tomatoes, Applewood Smoked Bacon & Mayonnaise"
      },
      %{
        name: "BUFFALO CHICKEN",
        description: "3 Grilled Buffalo Chicken, Lettuce, Tomatoes & Blue Cheese Dressing"
      },
      %{
        name: "Pesto Chicken",
        description:
          "Pesto, Grilled Chicken, Fresh Mozzarella, Lettuce, Tomatoes & Choice of Dressing"
      },
      %{
        name: "GYRO",
        description: "4 Grilled Beef, Lettuce, Tomatoes, Onions & Tzatziki Sauce"
      },
      %{
        name: "GYRO & FALAFEL",
        description: "4 Grilled Beef, Lettuce, Tomatoes, Onions & Tzatziki Sauce"
      },
      %{
        name: "THE LIVINGSTON",
        description: "Oven Gold Turkey Breast, Lettuce, Tomatoes, Honey Mustard & Mayonaise"
      },
      %{
        name: "ITALIANO",
        description:
          "Ham, Genoa Salami, Prosciutto, Provolone, Lettuce, Tomatoes, Onions, Banana Peppers, Roasted Red Peppers & Balsamic Vinaigrette"
      },
      %{
        name: "BLT",
        description: "Applewood Smoked Bacon, Lettuce, Tomatoes & Mayonaise"
      },
      %{
        name: "Classic Tuna",
        description: "Tuna, Lettuce, Tomatoes, Pickles, & Banana Peppers"
      },
      %{
        name: "Kofta Kabob wrap",
        description: "Seasoned Ground Beef, Onions, Lettuce, Tomatoes, Hummus & Tahini Dressing"
      },
      %{
        name: "Lamb Kabob wrap",
        description: "Lamb Kabob, Lettuce, Tomatoes, & Grilled Onions + Peppers"
      },
      %{
        name: "Leopold",
        description:
          "Ham, Cheese, Lettuce, Tomatoes, Honey Mustard & Mayonaise Choice of American, Swiss, or Provolone Cheese"
      }
    ]
  }
  # %{name: "Meals with rice"},
  # %{name: "Noodle dishes"},
  # %{name: "Salad / bowl base"},
  # %{name: "Included toppings"},
  # %{name: "Cold Sandwich"},
  # %{name: "Hot Sandwich"},
  # %{name: "Stuffed Pizza"},
  # %{name: "Regular/Thin Crust Pizza"}
]

Enum.each(category_items, fn ctg ->
  category = Lunchbot.Repo.get_by!(Category, name: "#{ctg.name}")

  Enum.each(ctg.items, fn item ->
    Lunchbot.Repo.insert!(%Item{
      name: item.name,
      description: item.description,
      category_id: category.id
    })
  end)
end)

headings =
  [
    %{name: "Protein", priority: 1},
    %{name: "Toppings", priority: 2},
    %{name: "Spice Level", priority: 1},
    %{name: "Dressing", priority: 2}
  ]
  |> Enum.each(fn hdg ->
    Lunchbot.Repo.insert!(%OptionHeading{name: hdg.name, priority: hdg.priority})
  end)

heading_options = [
  %{
    name: "Protein",
    option: [
      %{name: "Chicken"},
      %{name: "Ground Beef"},
      %{name: "Steak"},
      %{name: "Pork"},
      %{name: "Veggies"},
      %{name: "Tofu"},
      %{name: "No Protein"},
      %{name: "Grilled Chicken"},
      %{name: "Falafel"},
      %{name: "Gyro"},
      %{name: "Kofta (meatball)"},
      %{name: "Shredded lemon chicken"},
      %{name: "Mjedra (rice & lentils)"}
    ]
  },
  %{
    name: "Toppings",
    option: [
      %{name: "White rice"},
      %{name: "Brown rice"},
      %{name: "Cheese"},
      %{name: "Black beans"},
      %{name: "Pinto beans"},
      %{name: "Lettuce"},
      %{name: "Tomato"},
      %{name: "Tom Salsa"},
      %{name: "Corn salsa"},
      %{name: "Guacamole"},
      %{name: "Cilantro"},
      %{name: "Sour cream"}
    ]
  },
  %{name: "Spice Level", option: [%{name: "Regular"}, %{name: "Medium"}, %{name: "H-O-T!"}]},
  %{
    name: "Dressing",
    option: [
      %{name: "Tahani"},
      %{name: "Balsamic Vinaigrette"},
      %{name: "Honey Mustard"},
      %{name: "Greek"},
      %{name: "Italian"},
      %{name: "Blue Cheese"},
      %{name: "Caesar"}
    ]
  }
]

Enum.each(heading_options, fn hdg ->
  heading = Lunchbot.Repo.get_by!(OptionHeading, name: "#{hdg.name}")

  Enum.each(hdg.option, fn option ->
    Lunchbot.Repo.insert!(%Options{
      name: option.name,
      option_heading_id: heading.id
    })
  end)
end)

heading_items = [
  %{
    name: "Protein",
    items: [
      %{name: "Bowl"},
      %{name: "Burrito"},
      %{name: "GARDEN"},
      %{name: "GREEK"},
      %{name: "CAESAR"}
    ]
  },
  %{name: "Toppings", items: [%{name: "Bowl"}, %{name: "Burrito"}]},
  %{
    name: "Spice Level",
    items: [
      %{name: "TOFU SAAG"},
      %{name: "ALOO GOBHI"},
      %{name: "CHANA MASALA"},
      %{name: "BAINGAN BHARTA"},
      %{name: "KATHAL & POTATO MASALA"},
      %{name: "TOFU MANGO CURRY"},
      %{name: "TOFU MASALA"},
      %{name: "EGG & POTATO CURRY"},
      %{name: "PANEER (cheese) & PEPPER MAKHANI"},
      %{name: "MALAI KOFTA"},
      %{name: "PANEER MUSHROOM KORMA"},
      %{name: "MADRAS PANEER"},
      %{name: "SAAG PANEER"},
      %{name: "VEGETABLE TIKKA MASALA"},
      %{name: "PANEER TIKKA MASALA"},
      %{name: "CHICKPEA POUTINE"},
      %{name: "CHICKEN TIKKA MASALA"},
      %{name: "CHICKEN SAAG"},
      %{name: "CHICKEN MUSHROOM KORMA"},
      %{name: "CHICKEN & POTATO VINDALOO"},
      %{name: "MANGO CHICKEN"},
      %{name: "MADRAS CHICKEN"},
      %{name: "CHICKEN KADHAI"},
      %{name: "CHICKEN CURRY"},
      %{name: "CHICKEN TIKKA POUTINE"}
    ]
  },
  %{name: "Dressing", items: [%{name: "GARDEN"}, %{name: "GREEK"}, %{name: "CAESAR"}]}
]

Enum.each(heading_items, fn hdg ->
  heading = Lunchbot.Repo.get_by!(OptionHeading, name: "#{hdg.name}")

  Enum.each(hdg.items, fn item ->
    item = Lunchbot.Repo.get_by!(Item, name: "#{item.name}")

    Lunchbot.Repo.insert!(%ItemOptionHeadings{
      item_id: item.id,
      option_heading_id: heading.id
    })
  end)
end)
