# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :trax_web,
  namespace: TraxWeb,
  websocket_port: 8666

# Configures the endpoint
config :trax_web, TraxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "c8we/5M2wy+63Q+gXmEkidtL6FocgrRiHX26Z6B5WBv4dtHh2GPJMS5ZZ0uH/4a0",
  render_errors: [view: TraxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TraxWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :trax_web, :generators,
  context_app: :trax

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
