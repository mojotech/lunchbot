defmodule ServerPhoenix.Repo do
  use Ecto.Repo,
    otp_app: :server_phoenix,
    adapter: Ecto.Adapters.Postgres
end
