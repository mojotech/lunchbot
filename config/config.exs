# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :lunchbot,
  ecto_repos: [Lunchbot.Repo]

# Configures the endpoint
config :lunchbot, LunchbotWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: LunchbotWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Lunchbot.PubSub,
  live_view: [signing_salt: "fpRousrV"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :lunchbot, Lunchbot.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :lunchbot, Lunchbot.Scheduler,
  jobs: [
    # Check if it's noon in a office every hour and send slack lunch reminder if it is
    {"0 * * * *", {Lunchbot.Slackbot, :if_noon_on_monday_thursday_send_slack_message, []}}
  ]

config :torch,
  otp_app: :lunchbot,
  template_format: "eex"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
