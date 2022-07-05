defmodule LunchbotWeb.Token do
  @namespace "user salt"

  def sign(data) do
    Phoenix.Token.sign(LunchbotWeb.Endpoint, @namespace, data)
  end

  def verify(token) do
    Phoenix.Token.verify(
      LunchbotWeb.Endpoint,
      @namespace,
      token,
      max_age: 365 * 24 * 3600
    )
  end
end
