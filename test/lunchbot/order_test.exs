defmodule Lunchbot.OrderTest do
  use Lunchbot.DataCase

  alias Lunchbot.LunchbotData.{Order, OrderItem, OrderItemOptions, Item, Options}

  describe "#Order.get_total/1" do
    # These tests should only check the ORDER get_total/1,
    # leaving edge cases of Options, Items, etc, to their respective get_total/1 methods.
    test "order with singular item" do
      order = %Order{
        order_items: [
          %OrderItem{
            item: %Item{price: 22},
            order_item_options: []
          }
        ]
      }

      assert Order.get_total(order) == 22
    end

    test "order with multiple items" do
      order = %Order{
        order_items: [
          %OrderItem{
            item: %Item{price: 11},
            order_item_options: []
          },
          %OrderItem{
            item: %Item{price: 22},
            order_item_options: []
          },
          %OrderItem{
            item: %Item{price: 33},
            order_item_options: []
          }
        ]
      }

      assert Order.get_total(order) == 66
    end
  end

  describe "#OrderItem.get_total/1" do
    test "no order_item_options" do
      order_item = %OrderItem{
        item: %Item{
          price: 10
        },
        order_item_options: []
      }

      assert OrderItem.get_total(order_item) == 10
    end

    test "single order_item_options" do
      order_item = %OrderItem{
        item: %Item{
          price: 10
        },
        order_item_options: [
          %OrderItemOptions{
            option: %Options{
              extras: false,
              price: 10
            }
          }
        ]
      }

      assert OrderItem.get_total(order_item) == 20
    end

    test "multiple order_item_options" do
      order_item = %OrderItem{
        item: %Item{
          price: 44
        },
        order_item_options: [
          %OrderItemOptions{
            option: %Options{
              extras: false,
              price: 11
            }
          },
          %OrderItemOptions{
            option: %Options{
              extras: false,
              price: 22
            }
          },
          %OrderItemOptions{
            option: %Options{
              extras: false,
              price: 33
            }
          }
        ]
      }

      assert OrderItem.get_total(order_item) == 110
    end
  end

  describe "#OrderItemOptions.get_total/1" do
    test "order item option with no extras" do
      order_item_option = %OrderItemOptions{
        option: %Options{
          extras: false,
          price: 11
        }
      }

      assert OrderItemOptions.get_total(order_item_option) == 11
    end

    test "order item option with extras" do
      order_item_option = %OrderItemOptions{
        option: %Options{
          extra_price: 22,
          extras: true,
          price: 11
        }
      }

      assert OrderItemOptions.get_total(order_item_option) == 33
    end
  end
end
