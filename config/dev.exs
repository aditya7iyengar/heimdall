use Mix.Config

config :secure_storage, SecureStorage.Repo,
  username: System.get_env("HEIMDALL_DB_USERNAME", "heimdall_user"),
  password: System.get_env("HEIMDALL_DB_PASSWORD", "heimdall_password"),
  database: System.get_env("HEIMDALL_DB_NAME", "heimdall_dev"),
  hostname: System.get_env("HEIMDALL_DB_HOST", "localhost"),
  port: System.get_env("HEIMDALL_DB_PORT", "5432"),
  pool_size: 10,
  queue_interval: :timer.seconds(5)

config :bifrost, BifrostWeb.Endpoint,
  http: [port: System.get_env("BIFROST_PORT")],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../apps/bifrost/assets", __DIR__)
    ]
  ]

# Watch static and templates for browser reloading.
config :bifrost, BifrostWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/bifrost_web/(live|views)/.*(ex)$",
      ~r"lib/bifrost_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :bifrost, :basic_auth,
  username: System.get_env("BIFROST_USER"),
  password: System.get_env("BIFROST_PASSWORD")

config :heimdall_ql,
  username: System.get_env("BIFROST_USER"),
  password: System.get_env("BIFROST_PASSWORD")
