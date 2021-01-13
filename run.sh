#!/bin/bash

. ~/.bashrc
set -e

echo "Running npm install..."
cd assets && npm install

echo "Running mix setup commands..."
cd ..

mix ecto.create
mix ecto.migrate

echo "Starting server..."
mix phx.server
