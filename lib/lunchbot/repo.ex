defmodule Lunchbot.Repo do
  use Ecto.Repo,
    otp_app: :lunchbot,
    adapter: Ecto.Adapters.Postgres
end
