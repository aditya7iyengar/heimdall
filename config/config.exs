use Mix.Config

# Configures the endpoint
config :bifrost, BifrostWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RNWG6N61vLAFY86jkT1kLNex7OQOBjUIaTVHK2mfcRTSprNEcYDuJesW3lR4Yizg",
  render_errors: [view: BifrostWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Bifrost.PubSub,
  live_view: [signing_salt: "AukjfSqM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :bifrost, Bifrost.Scheduler,
  debug_logging: false,
  jobs: [
    # Every minute
    {"* * * * *", {Asguard.AesirSweeper, :run, []}}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
