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

alias Lunchbot.LunchbotData.{
  Category,
  Menu,
  MenuCategories,
  Item,
  OptionHeading,
  ItemOptionHeadings,
  Options
}

import Ecto.Query, only: [from: 2]

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
  %{name: "Saladworks", categories: [%{name: "Salad / bowl base"}]},
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
  %{
    name: "Bowl",
    items: [
      %{name: "Bowl", description: ""},
      %{name: "Falafel", description: ""},
      %{name: "Beef Shawarma", description: ""},
      %{name: "Grilled Chicken", description: ""},
      %{name: "Gyro", description: ""}
    ]
  },
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
      %{name: "CAESAR", description: ""},
      %{name: "Garden Salad", description: "mixed greens cucumber, carrot, red onion and tomato"},
      %{name: "BLTT Salad", description: "mixed greens, tomato, crispy bacon, and turkey breast"},
      %{
        name: "Antipasto",
        description:
          "capicola, soppressata, and genoa with sharp provolone, kalamata olives, banana peppers, red onion, roasted red peppers and tomato on a bed of greens"
      },
      %{
        name: "Spinach Salad",
        description:
          "spinach, bacon, apple, red onion, hard-boiled egg, dried cranberries and raspberry vinaigrette"
      },
      %{
        name: "Caesar",
        description: "fresh romaine, caesar dressing, grated parmesan and house-made croutons"
      },
      %{
        name: "Greek",
        description:
          "Mixed Greens, Kalamata Olives, Cucumber, Banana Peppers, Red Onion, Tomato, and Narragansett Creamery Feta"
      },
      %{
        name: "Antipasto",
        description:
          "Imported Italian salami, honey ham, provolone cheese, cucumber, red onion, black olives, and tomatoes served over our house salad"
      },
      %{
        name: "Chef Salad",
        description:
          "Honey ham, turkey, provolone cheese, and hard-boiled egg served over our house salad"
      },
      %{
        name: "House Salad",
        description: "Fresh iceberg lettuce, tomatoes, cucumbers, red onions, and black olives."
      },
      %{
        name: "Tuna Salad",
        description:
          "A generous scoop of our delicious homemade white tuna salad served over our house salad"
      },
      %{
        name: "Greek Salad",
        description:
          "Iceberg lettuce, tomato, cucumber, red onion, green pepper, kalamata olives, topped with feta cheese and served with a side of greek dressing"
      },
      %{
        name: "Chicken Fingers Salad",
        description: "Sicilia's house salad topped with crispy fried chicken fingers"
      },
      %{
        name: "Buffalo Chicken Fingers Salad",
        description: "Crispy chicken fingers tossed in buffalo sauce, served over our house salad"
      },
      %{
        name: "Grilled or Crispy Chicken Caesar Salad",
        description:
          "Romaine lettuce tossed with shaved parmesan cheese & croutons, topped with strips of grilled chicken OR crispy chicken fingers"
      },
      %{
        name: "Sicilia's Salad",
        description:
          "Greek salad topped with our famous signature homemade marinated grilled chicken breast"
      },
      %{
        name: "Mediterranean Chicken Salad",
        description: "House salad topped with our homemade marinated grilled chicken breast"
      },
      %{
        name: "Traditional Garden Salad",
        description:
          "Tomatoes, Shredded Carrots, Cucumbers, Red Onions, Lacey Swiss Cheese, finished with Italian Dressing"
      },
      %{
        name: "Bluto Salad",
        description:
          "Green Apples, Feta Cheese, Walnuts, Dried Cranberries finished with Balsamic Vinaigrette Dressing"
      },
      %{
        name: "My Big Fat Greek Salad",
        description:
          "Roasted Red Peppers, Banana Peppers, Red Onions, Kalamata Olives, Feta, finished with a Garlic Lemon Dressing"
      },
      %{
        name: "Falafel Salad",
        description:
          "Falafel, Hommus, Pickled Turnips, Tabouleh, Red Onions with a Tahini dressing"
      },
      %{
        name: "Chicken Caesar Salad",
        description: "Croutons, Chopped Bacon, Parmesan Cheese, Grilled Chicken, Caesar Dressing"
      },
      %{
        name: "Buffalo Chicken Salad",
        description:
          "Tomatoes, Cucumbers, Red Onions, Crumbled Gorgonzola Cheese, Buffalo Chicken, Blue Cheese Dressing"
      },
      %{
        name: "AntiPasto",
        description:
          "Sliced Italian Meats, Sharp Provolone Cheese, Red Roasted Peppers, Kalamata, Olives, Banana Peppers, Red Onions, Italian Dressing"
      }
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
      },
      %{
        name: "THAT'S NOT KOSHER",
        description:
          "rispy Bacon, Thin Sliced Pork Loin, Applewood Smoked Ham, Sliced Apple, Cheddar Cheese and Deli Mustard Pressed on a Buono's Sub Roll"
      },
      %{
        name: "Ploughman",
        description:
          "Applewood Smoked Ham, Cheddar Cheese, Mango Chutney, Red Onion, Lettuce & Tomato on a Buono's Bakery Sub Roll"
      },
      %{
        name: "Curried Turkey Salad",
        description:
          "Shredded Turkey mixed with Curry Mayo, Raisins, Carrot, and Celery with Lettuce & Tomato in a Whole Wheat Wrap"
      },
      %{
        name: "Cuban",
        description:
          "Applewood Smoked Ham, Thin Sliced Mustard Crusted Pork Loin, Swiss Cheese, Sliced Pickles Pressed on a Buono's Bakery Sub Roll"
      },
      %{
        name: "Apple Valley Turkey",
        description:
          "turkey breast, bacon, sliced apple, red onion, cheddar, sundried tomato mayonnaise on toasted whole wheat"
      },
      %{
        name: "Grinder",
        description:
          "hot capicola, soppressata, genoa, sharp provolone, lettuce, tomato, red onion, oil & vinegar and house-made sun-dried tomato & banana pepper relish on a Buono's sub roll"
      },
      %{
        name: "Turkey Breast",
        description: "with lettuce, tomato, and mayo on whole wheat"
      },
      %{
        name: "Thanksgiving 365",
        description: "turkey breast, herb stuffing, cranberry sauce & mayo on a Buono's sub roll"
      },
      %{
        name: "Tuna",
        description: "lightly dressed albacore tuna with diced celery, lettuce & tomato on wheat"
      },
      %{
        name: "Chicken Salad",
        description:
          "house-made chicken salad with diced apple, celery, fresh dill, locally dried cranberries, lettuce & tomato on a kaiser"
      },
      %{
        name: "BLT",
        description:
          "lettuce, ripe tomato and plenty of bacon with a touch of mayo on toasted wheat"
      },
      %{
        name: "BLTA",
        description: "BLT with avocado"
      },
      %{
        name: "BLTT",
        description: "BLT with turkey breast and a touch of mayo on toasted whole wheat"
      },
      %{
        name: "BLTTA",
        description: "BLTT with avocado"
      },
      %{
        name: "Chicken Caesar Wrap",
        description:
          "diced chicken, romaine lettuce, parmesan, caesar dressing and croutons in a whole wheat wrap"
      },
      %{
        name: "Deviled Egg Salad",
        description: "with just the right amount of mustard, lettuce and tomato on white"
      },
      %{
        name: "Roast Beef Dijonnaise",
        description:
          "medium rare roast beef, cheddar, dijon mayo, lettuce & tomato on a toasted kaiser"
      },
      %{
        name: "VEGAN Hummus",
        description:
          "with bell pepper, red onion, spinach, cucumber & carrot in a whole wheat wrap"
      },
      %{
        name: "VEGAN Spicy Black Bean Burger",
        description: "arugula, tomato on a roll (add avocado, relish or hummus below)"
      },
      %{
        name: "Vegetarian Spicy Black Bean Burger",
        description: "arugula, tomato and sun-dried tomato mayo on a kaiser"
      },
      %{
        name: "Cold Veggie Sub",
        description:
          "Lettuce, tomatoes, pickles, green peppers, black olives, onions topped with Italian house dressing"
      },
      %{
        name: "Grilled Veggie Sub",
        description:
          "Grilled mushrooms, onions, green peppers, topped with American cheese, served on an Italian sub"
      },
      %{
        name: "Gyro",
        description: "Beef, tzatziki, onions, lettuce and tomatoes"
      },
      %{
        name: "Combination",
        description:
          "A combination of our delicious meatballs and our special link sausage, topped with marinara sauce"
      },
      %{
        name: "Steak and Cheese",
        description: "Extra lean shaved steak with American cheese toasted on an Italian sub"
      },
      %{
        name: "Italian Sausage",
        description:
          "Lean juicy sausage loaded with grilled onions and green peppers, served on an Italian sub"
      },
      %{
        name: "Italian",
        description:
          "Smoked honey ham, genoa salami, provolone, lettuce, tomatoes & red onions topped with our house Italian dressing on an Italian sub"
      },
      %{
        name: "Ham & Cheese",
        description:
          "Layers of smoked honey ham and provolone cheese, with lettuce tomatoes red onions and mayonnaise on an Italian sub"
      },
      %{
        name: "Veal Parmigiana",
        description:
          "tender veal cutlets with our signature marinara sauce, topped with melted mozzarella cheese, toasted on an Italian sub"
      },
      %{
        name: "Meatball Sandwich",
        description:
          "Our delicious meatballs topped with marinara sauce, served on an Italian sub"
      },
      %{
        name: "Chicken Breast Cutlet",
        description:
          "Fried breaded chicken breast served with lettuce tomato and mayonnaise served on an Italian sub"
      },
      %{
        name: "Chicken Finger Sandwich",
        description: "Chicken fingers with lettuce tomato and honey mustard on an Italian sub"
      },
      %{
        name: "Chicken Parmigiana",
        description:
          "Breaded chicken breast cutlets with our signature marinara sauce, with melted mozzarella cheese, toasted on an Italian sub"
      },
      %{
        name: "Mediterranean Chicken Sandwich",
        description:
          "Grilled chicken breast marinated with our house Italian dressing served on pita bread with lettuce tomatoes and cucumber sauce"
      },
      %{
        name: "Eggplant Parmigiana",
        description:
          "Lightly breaded and fried eggplant with marinara sauce, topped with melted mozzarella cheese, toasted on an Italian sub."
      },
      %{
        name: "Turkey Club",
        description:
          "Slices of smoked turkey breast with American cheese, bacon, lettuce, tomato, mayonnaise, toasted on an Italian sub"
      },
      %{
        name: "Chicken Caesar Wrap",
        description:
          "Grilled chicken, romaine lettuce, shaved parmesan cheese, with caesar dressing in a garlic herb wrap"
      },
      %{
        name: "Chicken Philly",
        description:
          "Thin slices of grilled chicken breast, topped with American cheese on an Italian sub"
      },
      %{
        name: "Buffalo Chicken Wrap",
        description:
          "Buffalo chicken fingers with lettuce and tomato on an Italian sub. Your choice of blue cheese or ranch dressing"
      },
      %{
        name: "Turkey",
        description:
          "Slices of smoked turkey breast with lettuce tomato & mayonnaise. Served an Italian sub"
      },
      %{
        name: "Tuna",
        description: "lettuce, tomato, on an Italian sub"
      },
      %{
        name: "Buffalo Chicken Wrap",
        description:
          "Buffalo Chicken, Tomatoes, Lettuce, Cucumbers, Red Onions, Crumbled Gorgonzola, Drizzled with Blue Cheese Dressing"
      },
      %{
        name: "Chicken Caesar Wrap",
        description:
          "Grilled Chicken, Lettuce, Parmesan Cheese, Pita Chips, Bacon, Caesar Dressing"
      },
      %{
        name: "Rolfe Square Wrap",
        description:
          "Turkey, Lacey Swiss Cheese, Avocado, Cucumber, Shredded Carrots, Lettuce, Italian Dressing"
      },
      %{
        name: "Tuna Wrap",
        description: "Tuna, Tomatoes, Red Onions, Chopped Pickles"
      },
      %{
        name: "The Hill",
        description:
          "Italian Prosciutto, Fresh Mozzarella Cheese, Tomatoes, Roasted Red Peppers, Basil, Balsamic Vinegar and Olive Oil"
      },
      %{
        name: "Italian Grinder",
        description:
          "Mortadella, Salami, Hot Capocollo, Ham, Sharp Provolone Cheese, Tomatoes, Lettuce, Red Onions, Chopped Pickles, Banana Peppers, Red Vinegar and Olive Oil"
      },
      %{
        name: "Turkey Pesto",
        description:
          "Ovengold Turkey, Creamy Havarti Cheese, Tomatoes, Lettuce, Dried Cranberries, Garlic Pesto Mayo"
      },
      %{
        name: "Smokey",
        description:
          "Mesquite Smoked Turkey, Gouda Cheese, Lettuce, Sliced Green Apple, Garlic Pesto Mayo"
      },
      %{
        name: "Armen-Hammer",
        description:
          "Roast Beef, Jalapeño Havarti Cheese, Roasted Red Peppers, Red Onions, Tomatoes, Spicy Salsa Mayo"
      },
      %{
        name: "Muenster Mash",
        description:
          "Ham, Muenster Cheese, Tomatoes, Lettuce, Shredded Carrots, Horseradish Dressing"
      },
      %{
        name: "Atomic Bomb",
        description: "Grilled Chicken, Vermont Cheddar Cheese, Bacon, Garlic Pesto Mayo"
      },
      %{
        name: "Pastrami Reuben",
        description: "Thinly Sliced Pastrami, Swiss Cheese, Russian Dressing, Grilled on Deli Rye"
      },
      %{
        name: "Classic BLT",
        description:
          "Applewood Smoked Crispy Bacon, Lettuce, Tomatoes, Mayo, Grilled on Rye Bread"
      },
      %{
        name: "Chicken Salad BLT",
        description: "Applewood Smoked Crispy Bacon, Lettuce, Tomatoes, Mayo, Grilled on Rye"
      },
      %{
        name: "Eggplant Special",
        description: "Marinated Eggplant, Grilled Chicken, Tomatoes, Mozzarella Cheese"
      },
      %{
        name: "Sonia's Falafel",
        description:
          "Falafel, Tomatoes, Lettuce, Red Onions, Tabouleh, Banana Peppers, Hommus, Tahini Dressing, Wrapped in Pita Bread"
      },
      %{
        name: "Syrian Falafel",
        description:
          "Hommus, Falafel, Tomatoes, Parsley, Pickled Turnips, Red Hot Pepper, Banana Peppers, Tahini Dressing, Wrapped in Pita Bread"
      },
      %{
        name: "Hommus Wrap",
        description:
          "Hommus, Tomatoes, Lettuce, Red Onions, Tabouleh, Banana Peppers, Cucumbers, Wrapped in Pita Bread"
      },
      %{
        name: "BabaGanoush Wrap",
        description:
          "BabaGanoush, Lettuce, Armenian Cracked Wheat Salad, Kalamata, Olives, Banana Peppers, Wrapped in Pita Bread"
      },
      %{
        name: "Beef Shawarma",
        description:
          "Seasoned Sliced Beef, Tomatoes, Parsley, Pickled Turnips, Red Onions, Garlic Toum Sauce, Wrapped in Pita Bread"
      },
      %{
        name: "Chicken Gyro",
        description:
          "Grilled Chicken, Tomatoes, Lettuce, Red Onions, Banana Peppers, Tzatziki Sauce, Wrapped in Greek Flat Bread"
      },
      %{
        name: "Supreme Gyro",
        description:
          "Gyro, Tomatoes, Lettuce, Red Onions, Feta Cheese, Banana Peppers, Tzatziki Sauce, Wrapped in Greek Flat Bread"
      }
    ]
  },
  %{
    name: "Meals with rice",
    items: [
      %{
        name: "Chang's Vegetarian (tofu)",
        description: "Lettuce Wraps w/side of rice"
      },
      %{
        name: "Chang's Chicken",
        description: "Lettuce Wraps w/side of rice"
      },
      %{
        name: "Chang's Spicy Chicken Bowl",
        description: "Signature sweet-spicy chili sauce, green onion"
      },
      %{
        name: "Kung Pao Chicken Bowl",
        description: "Spicy Sichuan chili sauce, peanuts, green onion, red chili peppers"
      },
      %{
        name: "Sesame Chicken Bowl",
        description: "Sesame sauce, broccoli, bell peppers, onion"
      },
      %{
        name: "Ginger Chicken with Broccoli Bowl",
        description: "Ginger-garlic aromatics, green onion, steamed broccoli"
      },
      %{
        name: "Mongolian Beef Bowl",
        description: "Sweet soy glaze, flank steak, garlic, snipped green onion"
      },
      %{
        name: "Beef with Broccoli Bowl",
        description: "Flank steak, ginger-garlic aromatics, green onion, steamed broccoli"
      },
      %{
        name: "Kung Pao Shrimp Bowl",
        description: "Spicy Sichuan chili sauce, peanuts, green onion, red chili peppers"
      },
      %{
        name: "Buddha's Feast STIRFRY",
        description:
          "Five-spice tofu, savory sauce, green beans, shiitakes, broccoli, carrots in stir-fry sauce"
      },
      %{
        name: "Buddha's Feast STEAMED",
        description: "Five-spice tofu, savory sauce, green beans, shiitakes, broccoli, carrots"
      },
      %{
        name: "Ma Po Tofu",
        description: "Crispy silken tofu, spicy red chili sauce, steamed broccoli"
      }
    ]
  },
  %{
    name: "Noodle dishes",
    items: [
      %{
        name: "Singapore Street Noodles",
        description: "rice noodles, light curry sauce, CHICKEN & SHRIMP, onion, vegetables"
      },
      %{name: "Pad Thai w/tofu", description: ""},
      %{name: "Pad Thai w/chicken", description: ""},
      %{name: "Lo Mein w/beef", description: ""},
      %{name: "Lo Mein w/chicken", description: ""},
      %{name: "Lo Mein w/tofu", description: ""}
    ]
  },
  %{
    name: "Salad / bowl base",
    items: [
      %{name: "Power Grains", description: "quinoa, farro, brown rice"},
      %{name: "Spiral pasta", description: ""},
      %{name: "Romain/iceberg blend", description: ""},
      %{name: "Super greens", description: "romaine, kale, radicchio, frisee"},
      %{name: "Baby Spinach", description: ""},
      %{name: "Chopped Kale", description: ""},
      %{name: "Spring Mix", description: ""}
    ]
  },
  %{
    name: "Cold Sandwich",
    items: [
      %{
        name: "Allitalla",
        description:
          "Prosciutto, capocollo, pepperoni and provolone, tomato, pickles, onions, oil, oregano, hot relish and pepperoncini."
      },
      %{
        name: "Deluxe",
        description:
          "Salami, ham, pepperoni and provolone, tomato, pickles, onions, oil, oregano, hot relish and pepperoncini"
      },
      %{
        name: "Italian Connection",
        description:
          "Served on a croissant with Genoa salami, capocollo, pepperoni and provolone, tomato, pickles, onions, oil, oregano, hot relish and pepperoncini."
      },
      %{name: "Roast Beef", description: "Served with lettuce, tomato, pickles, onions and mayo"},
      %{name: "MTP", description: "Fresh mozzarella, tomato and pesto, balsamic and oregano."},
      %{
        name: "Veggie Sandwich with Cheese",
        description:
          "Lettuce, tomato, pickles, onions, roasted reds and provolone cheese. Served with extra virgin olive oil, balsamic and oregano"
      },
      %{
        name: "Roasted Turkey",
        description: "Served with lettuce, tomato, pickles, onions and mayo"
      },
      %{
        name: "Willowtree Chicken Salad",
        description: "Served with lettuce, tomato, pickles and onions."
      },
      %{name: "Tuna Salad", description: "Served with lettuce, tomato, pickles and onions."},
      %{
        name: "Mambo",
        description: "Sopressata, Smoked Mozz, Olive salad, Arugula, Tomatoes, EVOO, and balsamic"
      }
    ]
  },
  %{
    name: "Hot Sandwich",
    items: [
      %{
        name: "Chicken Cutlet",
        description:
          "Hut-fried chicken, roasted red peppers, sriracha mayo, fresh mozzarella, and fresh ground black pepper."
      },
      %{
        name: "Meatball Parm",
        description: "Hut-made meatball sandwich served with melted provolone cheese"
      },
      %{name: "Eggplant Parm", description: "Melted provolone"},
      %{name: "Sausage", description: "Peppers, Onions, provolone"},
      %{name: "Meatball & Cheese", description: "Sauce and provolone"},
      %{name: "Chicken Parmigiano", description: "Sauce and provolone"},
      %{
        name: "Sriracha Fried Chicken",
        description: "Lettuce, tomatoes, sweet pickles, banana peppers, and sriracha mayo"
      },
      %{
        name: "Shaved Steak",
        description: "Shaved steak, hot pepper seeds, sriracha mayo, and melted provolone"
      },
      %{
        name: "Shaved Steak with the Works",
        description: "pepper, mushrooms, onions and cheese."
      },
      %{
        name: "Grilled Veggie Wrap",
        description:
          "Grilled peppers, mushrooms, onions, and provolone cheese. Served on a wheat wrap"
      },
      %{name: "GCP", description: "Grilled chicken with pesto, lettuce, tomato and mayo"},
      %{name: "BLT", description: "Served on toasted multigrain with mayo"},
      %{name: "Grilled Chicken", description: "Lettuce, tomato and mayo"}
    ]
  },
  %{
    name: "Stuffed Pizza",
    items: [
      %{name: "Baby STUFFED Cheese", description: ""},
      %{name: "Baby STUFFED VEGAN veggie", description: "no cheese"}
    ]
  },
  %{
    name: "Regular/Thin Crust Pizza",
    items: [
      %{name: "Baby Regular", description: ""},
      %{name: "Baby Thin Crust", description: ""}
    ]
  }
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
    %{name: "Dressing", priority: 3},
    %{name: "Rice type", priority: 1},
    %{name: "Roll on side", priority: 4},
    %{name: "Sub size", priority: 1}
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
      %{name: "Mjedra (rice & lentils)"},
      %{name: "Scoop of chicken salad"},
      %{name: "Scoop tuna salad"},
      %{name: "Diced chicken"},
      %{name: "Bean burger"},
      %{name: "Falafel"},
      %{name: "Grilled Chicken"},
      %{name: "Sliced Turkey"},
      %{name: "Gyro"},
      %{name: "Chicken Salad "},
      %{name: "Tuna Salad"},
      %{name: "Beef Shawarma"},
      %{name: "Grilled Vegetables"}
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
      %{name: "Sour cream"},
      %{name: "Baked Tofu"},
      %{name: "Crispy Chicken"},
      %{name: "Grilled Buffalo Chicken"},
      %{name: "Grilled Chicken"},
      %{name: "Sweet Chili Crispy Chicken"},
      %{name: "Pepperoni"},
      %{name: "Roasted Turkey"},
      %{name: "Smoked Ham"},
      %{name: "Smoky Bacon"},
      %{name: "Sliced Egg"},
      %{name: "Pepper Jack Cheese"},
      %{name: "Shredded Mozzerela"},
      %{name: "Feta"},
      %{name: "Provalone Cheese"},
      %{name: "Cheddar Cheese"},
      %{name: "Blue Cheese"},
      %{name: "Tomato"},
      %{name: "Cucumber"},
      %{name: "Sliced banana peppers"},
      %{name: "Edemame"},
      %{name: "Fresh Broccoli"},
      %{name: "Roasted Broccoli"},
      %{name: "Matchstick carrots"},
      %{name: "Diced Red Onion"},
      %{name: "Kalamata Olives"},
      %{name: "Avocado"},
      %{name: "Fire-roasted corn & bean medly"},
      %{name: "Roasted Red Peppers"},
      %{name: "Roasted Brussel Sprouts"},
      %{name: "Roasted Butternut Squash"},
      %{name: "Roasted Cauliflower"},
      %{name: "Sweet Corn"},
      %{name: "Dried cranberries"},
      %{name: "Red grapes"},
      %{name: "Mandarin Oranges"},
      %{name: "Diced apple"},
      %{name: "Croutons"},
      %{name: "Crispy Wonton Strips"},
      %{name: "Tortilla Strips"},
      %{name: "Walnuts"},
      %{name: "Smoky Chickpeas"},
      %{name: "Honey Pecans"},
      %{name: "Sunflower Seeds"},
      %{name: "Onion Crisps"},
      %{name: "Mushroom"},
      %{name: "Green Pepper"},
      %{name: "Broccoli"},
      %{name: "Pepperoni"},
      %{name: "Black Olives"},
      %{name: "Green Olives"},
      %{name: "Onions"},
      %{name: "Garlic"},
      %{name: "Eggplant"},
      %{name: "Pineapple"},
      %{name: "Jalapeño"},
      %{name: "Bacon"},
      %{name: "Ham"},
      %{name: "Sausage"},
      %{name: "Chicken"},
      %{name: "Buffalo Chicken"},
      %{name: "VEGAN (no cheese)"}
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
      %{name: "Caesar"},
      %{name: "Balsamic Vinaigrette"},
      %{name: "Creamy Blue Cheese"},
      %{name: "Greek Vinaigrette"},
      %{name: "Honey Mustard"},
      %{name: "Lemon & Olive Oil Vinaigrette"},
      %{name: "Italian Vinaigrette"},
      %{name: "Light Raspberry Vinaigrette"},
      %{name: "Caesar"},
      %{name: "Creamy French"},
      %{name: "Chipotle Ranch"},
      %{name: "Salsa Ranch"},
      %{name: "Light Ranch"},
      %{name: "Ranch"},
      %{name: "Sweet Sesame"},
      %{name: "Thousand Island"},
      %{name: "Creamy Italian"},
      %{name: "French"},
      %{name: "Ranch"},
      %{name: "Balsamic Vinegar"},
      %{name: "Greek"},
      %{name: "Blue Cheese"},
      %{name: "House Vinaigrette"},
      %{name: "Tzatziki Sauce"},
      %{name: "Hummus"},
      %{name: "Garlic Toum Sauce"},
      %{name: "Sesame Tahini"}
    ]
  },
  %{name: "Rice type", option: [%{name: "White rice"}, %{name: "Brown rice"}]},
  %{name: "Roll on side", option: [%{name: "Yes"}, %{name: "No"}]},
  %{name: "Sub size", option: [%{name: "Small"}, %{name: "Large"}]}
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
      %{name: "CAESAR"},
      %{name: "Garden Salad"},
      %{name: "BLTT Salad"},
      %{name: "Antipasto"},
      %{name: "Spinach Salad"},
      %{name: "Caesar salad"},
      %{name: "Greek salad"},
      %{name: "Traditional Garden Salad"},
      %{name: "Bluto Salad"},
      %{name: "My Big Fat Greek Salad"},
      %{name: "Falafel Salad"},
      %{name: "Chicken Caesar Salad"},
      %{name: "Buffalo Chicken Salad"},
      %{name: "AntiPasto"}
    ]
  },
  %{
    name: "Toppings",
    items: [
      %{name: "Bowl"},
      %{name: "Burrito"},
      %{name: "Power Grains"},
      %{name: "Spiral pasta"},
      %{name: "Romain/iceberg blend"},
      %{name: "Super greens"},
      %{name: "Baby Spinach"},
      %{name: "Chopped Kale"},
      %{name: "Spring Mix"},
      %{name: "Baby STUFFED Cheese"},
      %{name: "Baby STUFFED VEGAN veggie"},
      %{name: "Baby Regular"},
      %{name: "Baby Thin Crust"}
    ]
  },
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
  %{
    name: "Dressing",
    items: [
      %{name: "GARDEN"},
      %{name: "GREEK"},
      %{name: "CAESAR"},
      %{name: "Power Grains"},
      %{name: "Spiral pasta"},
      %{name: "Romain/iceberg blend"},
      %{name: "Super greens"},
      %{name: "Baby Spinach"},
      %{name: "Chopped Kale"},
      %{name: "Spring Mix"},
      %{name: "Antipasto"},
      %{name: "Chef Salad"},
      %{name: "House Salad"},
      %{name: "Tuna Salad"},
      %{name: "Greek Salad"},
      %{name: "Chicken Fingers Salad"},
      %{name: "Buffalo Chicken Fingers Salad"},
      %{name: "Grilled or Crispy Chicken Caesar Salad"},
      %{name: "Sicilia's Salad"},
      %{name: "Mediterranean Chicken Salad"},
      %{name: "Falafel"},
      %{name: "Beef Shawarma"},
      %{name: "Grilled Chicken"},
      %{name: "Gyro"}
    ]
  },
  %{
    name: "Rice type",
    items: [
      %{name: "Chang's Vegetarian (tofu)"},
      %{name: "Chang's Chicken"},
      %{name: "Chang's Spicy Chicken Bowl"},
      %{name: "Kung Pao Chicken Bowl"},
      %{name: "Sesame Chicken Bowl"},
      %{name: "Ginger Chicken with Broccoli Bowl"},
      %{name: "Mongolian Beef Bowl"},
      %{name: "Beef with Broccoli Bowl"},
      %{name: "Kung Pao Shrimp Bowl"},
      %{name: "Buddha's Feast STIRFRY"},
      %{name: "Buddha's Feast STEAMED"},
      %{name: "Ma Po Tofu"}
    ]
  },
  %{
    name: "Roll on side",
    items: [
      %{name: "Power Grains"},
      %{name: "Spiral pasta"},
      %{name: "Romain/iceberg blend"},
      %{name: "Super greens"},
      %{name: "Baby Spinach"},
      %{name: "Chopped Kale"},
      %{name: "Spring Mix"}
    ]
  },
  %{
    name: "Sub size",
    items: [
      %{name: "Allitalla"},
      %{name: "Deluxe"},
      %{name: "Italian Connections"},
      %{name: "Roast Beef"},
      %{name: "MTP"},
      %{name: "Veggie Sandwich with Cheese"},
      %{name: "Roasted Turkey"},
      %{name: "Willowtree Chicken Salad"},
      %{name: "Tuna Salad"},
      %{name: "Mambo"},
      %{name: "Chicken Cutlet"},
      %{name: "Meatball Parm"},
      %{name: "Eggplant Parm"},
      %{name: "Sausage"},
      %{name: "Meatball & Cheese"},
      %{name: "Chicken Parmigiano"},
      %{name: "Sriracha Fried Chicken"},
      %{name: "Shaved Steak"},
      %{name: "Shaved Steak with the Works"},
      %{name: "Grilled Veggie Wrap"},
      %{name: "GCP"},
      %{name: "BLT"},
      %{name: "Grilled Chicken"}
    ]
  }
]

Enum.each(heading_items, fn hdg ->
  heading = Lunchbot.Repo.get_by!(OptionHeading, name: "#{hdg.name}")

  Enum.each(hdg.items, fn item ->
    items = from(i in Item, where: i.name == ^item.name) |> Lunchbot.Repo.all()

    Enum.each(items, fn it ->
      Lunchbot.Repo.insert!(%ItemOptionHeadings{
        item_id: it.id,
        option_heading_id: heading.id
      })
    end)
  end)
end)
