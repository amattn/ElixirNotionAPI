# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

config :logger, :console,
  format: "$time $metadata[$level] notion_api: $message\n",
  # dn is short convention for debug numbers
  metadata: [:dn, :"🐛", :request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
