# Litelist

### Dependencies

* Docker
* Docker Compose

### Run locally
1. Clone this repo
1. `cd Litelist`
1. `chmod +x run.sh`
1. Make sure ports 4000 and 5432 (postgres) are free. Run `brew services stop postgresql` on Mac.
1. `docker-compose build` Note: You only need to run this command the first time
1. `docker-compose run web mix amnesia.create --database Litelist.Settings.SettingsDatabase --disk` For more, see the Amnesia section below
1. `docker-compose up`
1. Go to localhost:4000
1. `docker-compose run web mix test` to run tests.

### Create first user
1. `docker-compose run web iex -S mix`
1. `import Litelist.Factory`
1. `attrs = %{username: "ADD_NAME_HERE"}` Note: Don't change the password attr. The password will default to 'password'.
1. `insert(:neighbor, attrs)`

### Test authentication
1. Go to localhost:4000 and login with credentials created from above
1. localhost:4000/secret can only be seen by authenticated users

Note: See Docker usage below for more commands.

### Current Issues
* Inconsistent live-reload while using Docker.

### Steps to recreate this repo
1. `mix phx.new litelist`
1. Set up Dockerfile, docker-compose.yml and run.sh.
1. Start from the Run Locally section above.

### Docker usage

Run commands prepended with `docker-compose run web`

`mix ecto.migrate` becomes `docker-compose run web mix ecto.migrate`

`mix ecto.migrate` becomes `docker-compose run web mix ecto.migrate`

### Amnesia database

Amnesia is an elixir wrapper around erlang's Mnesia database.

This database is used for settings because it has a stronger guarantee that it will be read than postgres has. As long as the site is up, the Mnesia SettingsDatabase should be available.

#### Setup

1. `docker-compose run web mix amnesia.create --database Litelist.Settings.SettingsDatabase --disk`

#### Test environment setup

1. `docker-compose run web /bin/bash`
1. `mkdir mnesia`
1. `MIX_ENV=test mix amnesia.create --database Litelist.Settings.SettingsDatabase --disk`

Some useful commands

* `docker-compose run web mix ecto.rollback`
* `docker-compose run web mix ecto.migrate`
* `docker-compose run web mix ecto.seed` Seeds the database
* `docker-compose run web mix test`
* `docker-compose run web /bin/bash`
* `MIX_ENV=test mix ecto.reset` Note: Reset test database after running the above command.
* `docker-compose run web mix coveralls`
* `docker-compose run web mix coveralls.detail`
* `docker-compose run web mix credo -a` Credo is a static code analysis tool for the Elixir language with a focus on code consistency and teaching.
* `docker-compose run web mix docs` Documents repo code. Check out docs/index.html
* `docker-compose run web mix format FILENAME` Formats a file according to Elixir standards
* `docker-compose run web mix amnesia.create --database Litelist.Settings.SettingsDatabase --disk` Create Mnesia database
* `docrw mix amnesia.drop -d Litelist.Settings.SettingsDatabase` Drop Mnesia database



