# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :materials,
  ecto_repos: [Materials.Repo]

# Configures the endpoint
config :materials, MaterialsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yNk3NbAO1JH2Qi6+MhCifnJFSCjjb7p2dgeyJrvVZzXE4n7ylhw0n1WIiSNz1SQP",
  render_errors: [view: MaterialsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Materials.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
