use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :litelist, LitelistWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :litelist, Litelist.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("TEST_POSTGRES_USER"),
  password: System.get_env("TEST_POSTGRES_PASSWORD"),
  database: System.get_env("TEST_POSTGRES_DB"),
  hostname: System.get_env("TEST_POSTGRES_HOST"),
  pool: Ecto.Adapters.SQL.Sandbox

# Speed up tests that use bcrypt
config :comeonin, :bcrypt_log_rounds, 4
