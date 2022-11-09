defmodule LunchbotWeb.LiveComponent.ModalLive do
  use Phoenix.LiveComponent

  import Phoenix.HTML.Form

  @defaults %{
    left_button: "Close",
    left_button_action: nil,
    left_button_param: nil,
    right_button: "Submit",
    right_button_action: nil,
    right_button_param: nil
  }

  def mount(socket) do
    {:ok, assign(socket, :selected_options, [])}
  end

  def update(%{id: _id} = assigns, socket) do
    {:ok, assign(socket, Map.merge(@defaults, assigns))}
  end

  def handle_event(
        "change_button",
        params,
        socket
      ) do
    target_item = params["_target"] |> Enum.at(0)

    socket =
      if(Enum.member?(socket.assigns.selected_options, target_item)) do
        assign(
          socket,
          :selected_options,
          List.delete(socket.assigns.selected_options, target_item)
        )
      else
        assign(socket, :selected_options, [target_item | socket.assigns.selected_options])
      end

    {:noreply, socket}
  end

  # Fired when user clicks right button on modal
  def handle_event(
        "right-button-click",
        _params,
        %{
          assigns: %{
            right_button_action: right_button_action,
            right_button_param: _right_button_param
          }
        } = socket
      ) do
    send(
      self(),
      {__MODULE__, :button_clicked,
       %{
         action: right_button_action,
         param: %{id: socket.assigns.id, selected_options: socket.assigns.selected_options}
       }}
    )

    {:noreply, socket}
  end

  def handle_event(
        "left-button-click",
        _params,
        %{
          assigns: %{
            left_button_action: left_button_action,
            left_button_param: left_button_param
          }
        } = socket
      ) do
    send(
      self(),
      {__MODULE__, :button_clicked, %{action: left_button_action, param: left_button_param}}
    )

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
      <div id={"modal-#{@id}"}>
      <!-- Modal Background -->
      <div class="modal-container"
          id={"item-#{@id}"}
          phx-hook="ScrollLock">
        <div class="modal-inner-container">
          <div class="modal-card">
            <div class="modal-inner-card">
              <!-- Title -->
              <%= if @title != nil do %>
              <div class="modal-title">
                <%= @title %>
              </div>
              <% end %>
              <%= if @description != "" do %>
              <div>
                <p class="modal-description"><%= @description %></p>
              </div>
              <% end %>

              <!-- Body -->
              <%= if @body != nil do %>
                <%= f = form_for :add_options, "#", id: @id, phx_change: "change_button", phx_target: @myself %>
                <div class="modal-body">
                <%= label f, :options, "Submit your item:" %>
                <%= for option_headings <- @body do %>
                  <h3><%= option_headings.name %></h3>
                  <ul class="order-item-list">
                  <%= for options <- option_headings.options do %>
                    <li>
                    <%= checkbox(f, :options, name: "#{options.name}", value: options.id, hidden_input: false, id: options.name) %>
                    <label for={options.name}><%= options.name %></label>
                    </li>
                  <% end %>
                  </ul>
                  <br>
                <% end %>
              </div>
              <% end %>

              <!-- Buttons -->
              <div class="modal-buttons">
                  <!-- Left Button -->
                  <button class="left-button"
                          type="button"
                          phx-click="left-button-click"
                          phx-target={"#item-#{@id}"}>
                    <div>
                      <%= @left_button %>
                    </div>
                  </button>
                  <!-- Right Button -->
                  <button class="right-button"
                          type="button"
                          phx-click="right-button-click"
                          phx-target={"#item-#{@id}"}>
                    <div>
                      <%= @right_button %>
                    </div>
                  </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
