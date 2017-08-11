# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :getting_started_elixir, GettingStartedElixirWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9/WsVfli//XqrDVN9Y3F2PvdNqEPk4UAddz7EcQkhp3gr365DWMz6zCZSkWGMxec",
  render_errors: [view: GettingStartedElixirWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GettingStartedElixir.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
