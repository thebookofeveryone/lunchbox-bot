# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :lunchbox_bot, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:lunchbox_bot, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

config :lunchbox_bot,
  slack_token: System.get_env("SLACK_TOKEN"),
  slack_channel: System.get_env("SLACK_CHANNEL")

##
# You can customise the greeting part of the matches message.
# Just uncomment the line below and change the message to the one you want.
##

# config :lunchbox_bot,
#   greeting: "It's the most exciting moment of the week again!\n There are the matches of this week:"
