#!/bin/bash
# add & to make these next 2 run in the background

# mix amnesia.create --database Litelist.Settings.SettingsDatabase --disk
# MIX_ENV=test mix amnesia.create --database Litelist.Settings.SettingsDatabase --disk

set -e

# cd assets && npm install

# cd ..
# mix deps.get
# mix ecto.create
# mix ecto.migrate

# Start the phoenix web server
source .env && mix phx.server
