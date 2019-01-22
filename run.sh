#!/bin/bash
# add & to make these next 2 run in the background
echo "Adding amnesia database (these will soon be removed)..."
mix amnesia.create --database Litelist.Settings.SettingsDatabase --disk
MIX_ENV=test mix amnesia.create --database Litelist.Settings.SettingsDatabase --disk

set -e

echo "Running npm install..."
cd assets && npm install

echo "Running mix setup commands..."
cd ..
mix deps.get
mix ecto.create
mix ecto.migrate

echo "Starting server..."
mix phx.server
