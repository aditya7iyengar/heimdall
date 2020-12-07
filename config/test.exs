use Mix.Config

config :secure_storage, SecureStorage.Repo,
  username: System.get_env("HEIMDALL_DB_TEST_USERNAME", "heimdall_user"),
  password: System.get_env("HEIMDALL_DB_TEST_PASSWORD", "heimdall_password"),
  database: System.get_env("HEIMDALL_DB_TEST_NAME", "heimdall_dev"),
  hostname: System.get_env("HEIMDALL_DB_TEST_HOST", "localhost"),
  port: System.get_env("HEIMDALL_DB_TEST_PORT", "5432"),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 60,
  queue_interval: :timer.seconds(5),
  queue_interval: :timer.seconds(30),
  timeout: :timer.seconds(60),
  ownership_timeout: :timer.seconds(90)

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bifrost, BifrostWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :bifrost, :basic_auth, username: "test_user", password: "secret"

config :heimdall_ql, username: "test_user", password: "secret"
