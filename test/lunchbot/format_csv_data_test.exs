defmodule Lunchbot.FormatCsvDataTest do
  use Lunchbot.DataCase

  alias Lunchbot.LunchbotData

  describe "format_orders/1" do
    # making sure that when there are no OfficeLunchOrder id's (nil)
    # that format_orders returns nil as will
    test "nil order struct passed" do
      orders = LunchbotData.format_orders(nil)

      assert orders == nil
    end

    test "3 orders all with one item, no options" do
      order_struct = [
        %Lunchbot.LunchbotData.Order{
          inserted_at: ~N[2022-08-12 15:13:10],
          order_items: [
            %Lunchbot.LunchbotData.OrderItem{
              item: "MTP",
              options: []
            }
          ],
          updated_at: ~N[2022-08-12 15:13:12],
          user: "user1"
        },
        %Lunchbot.LunchbotData.Order{
          inserted_at: ~N[2022-08-12 15:13:12],
          order_items: [
            %Lunchbot.LunchbotData.OrderItem{
              item: "Meatball & Cheese",
              options: []
            }
          ],
          updated_at: ~N[2022-08-12 15:13:12],
          user: "user2"
        },
        %Lunchbot.LunchbotData.Order{
          inserted_at: ~N[2022-08-12 15:13:31],
          order_items: [
            %Lunchbot.LunchbotData.OrderItem{
              item: "Sriracha Fried Chicken",
              options: []
            }
          ],
          updated_at: ~N[2022-08-12 15:13:31],
          user: "user3"
        }
      ]

      orders = LunchbotData.format_orders(order_struct)

      assert orders == [
               [~N[2022-08-12 15:13:10], "user1", "MTP"],
               [~N[2022-08-12 15:13:12], "user2", "Meatball & Cheese"],
               [~N[2022-08-12 15:13:31], "user3", "Sriracha Fried Chicken"]
             ]
    end

    test "3 orders all with one item that come with options" do
      order_struct = [
        %Lunchbot.LunchbotData.Order{
          inserted_at: ~N[2022-08-12 15:13:10],
          order_items: [
            %Lunchbot.LunchbotData.OrderItem{
              item: "GARDEN",
              options: ["Shredded lemon chicken", "Tzatziki Sauce"]
            }
          ],
          updated_at: ~N[2022-08-12 15:13:12],
          user: "user1"
        },
        %Lunchbot.LunchbotData.Order{
          inserted_at: ~N[2022-08-12 15:13:12],
          order_items: [
            %Lunchbot.LunchbotData.OrderItem{
              item: "Chef Salad",
              options: ["Ranch"]
            }
          ],
          updated_at: ~N[2022-08-12 15:13:12],
          user: "user2"
        },
        %Lunchbot.LunchbotData.Order{
          inserted_at: ~N[2022-08-12 15:13:31],
          order_items: [
            %Lunchbot.LunchbotData.OrderItem{
              item: "CAESAR",
              options: ["Grilled Chicken", "Balsamic Vinaigrette"]
            }
          ],
          updated_at: ~N[2022-08-12 15:13:31],
          user: "user3"
        }
      ]

      orders = LunchbotData.format_orders(order_struct)

      assert orders == [
               [
                 ~N[2022-08-12 15:13:10],
                 "user1",
                 "GARDEN w/ options: Shredded lemon chicken, Tzatziki Sauce"
               ],
               [~N[2022-08-12 15:13:12], "user2", "Chef Salad w/ options: Ranch"],
               [
                 ~N[2022-08-12 15:13:31],
                 "user3",
                 "CAESAR w/ options: Grilled Chicken, Balsamic Vinaigrette"
               ]
             ]
    end

    test "2 orders where one order has multiple items with options" do
      order_struct = [
        %Lunchbot.LunchbotData.Order{
          inserted_at: ~N[2022-08-12 15:13:10],
          order_items: [
            %Lunchbot.LunchbotData.OrderItem{
              item: "GARDEN",
              options: ["Shredded lemon chicken", "Tzatziki Sauce"]
            },
            %Lunchbot.LunchbotData.OrderItem{
              item: "Meatball & Cheese",
              options: ["Small"]
            },
            %Lunchbot.LunchbotData.OrderItem{
              item: "Sprite",
              options: ["Large"]
            }
          ],
          updated_at: ~N[2022-08-12 15:13:12],
          user: "user1"
        },
        %Lunchbot.LunchbotData.Order{
          inserted_at: ~N[2022-08-12 15:13:12],
          order_items: [
            %Lunchbot.LunchbotData.OrderItem{
              item: "Chef Salad",
              options: ["Ranch"]
            }
          ],
          updated_at: ~N[2022-08-12 15:13:12],
          user: "user2"
        }
      ]

      orders = LunchbotData.format_orders(order_struct)

      assert orders == [
               [
                 ~N[2022-08-12 15:13:10],
                 "user1",
                 "GARDEN w/ options: Shredded lemon chicken, Tzatziki Sauce",
                 "Meatball & Cheese w/ options: Small",
                 "Sprite w/ options: Large"
               ],
               [~N[2022-08-12 15:13:12], "user2", "Chef Salad w/ options: Ranch"]
             ]
    end
  end
end
