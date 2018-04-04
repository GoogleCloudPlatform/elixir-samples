use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :google_oauth2_example, GoogleOAuth2Example.Endpoint,
  http: [port: 4000],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Set a higher stacktrace during test
config :phoenix, :stacktrace_depth, 20
