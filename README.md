# Lunchbot

To start postgresql:

`docker-compose up -d`

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Google

In order to set up the API keys for the Google authentication and integration with Elixir, simply follow the instructions found [here](https://github.com/dwyl/elixir-auth-google/blob/main/create-google-app-guide.md). The API keys are stored in `.env` as follows:
- `GOOGLE_CLIENT_ID=<Client ID>`
- `GOOGLE_CLIENT_SECRET=<Client Secret>`

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
