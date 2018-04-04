# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the namespace used by Phoenix generators
config :google_oauth2_example,
  app_namespace: GoogleOAuth2Example

# Configures the endpoint
config :google_oauth2_example, GoogleOAuth2Example.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zWoDIUN+sA1X958CxqY38CE42MrplMBZtnCOs+d1DoE05sJ++vfrrAU8OKm3JPL+",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: GoogleOAuth2Example.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
