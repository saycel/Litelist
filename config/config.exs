# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config
alias Litelist.Schedulers.RemoveOldPosts

# General application configuration
config :litelist,
  ecto_repos: [Litelist.Repo]

# Configures the endpoint
config :litelist, LitelistWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "t7xDZDFhYMkS4p6ahxhxDJLsC8ZNl1Jfo4OGdAVyTm01VO4DmYFtmK8/qUGscrkS",
  render_errors: [view: LitelistWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Litelist.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure Guardian
config :litelist, Litelist.Auth.Guardian,
  issuer: "listlist", # Name of your app/company/product
  secret_key: "cUb/WWOf1Pe8Q7QQ3fxwSWqnuA7oGohzLUYySEt6UrVREONqudCD3uh83jMviUpz"

config :litelist, Litelist.Scheduler,
  jobs: [
    {"@daily", {RemoveOldPosts, :run, []}}
  ]

config :arc,
  storage: Arc.Storage.Local
  
config :litelist,
  max_flagged_posts: 5,
  allow_replies: false,
  name: "Litelist"

config :phoenix, :json_library, Jason