# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chatter,
  ecto_repos: [Chatter.Repo]

# Configures the endpoint
config :chatter, ChatterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qBDwgpHm7f2Wdzb7xkspMUiw8eXMQBqGA0RSjA+OnP7Ejk1Dva3rkC+SLBmgfB3q",
  render_errors: [view: ChatterWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Chatter.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian
config :chatter, Chatter.Guardian,
  issuer: "chatter",
  secret_key: "tlj7s/68punpQHpUIHLG4UXW5uKDjYraiGEs4PvPtuq8Z3RgET1fgznyEsz1+jHa"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
