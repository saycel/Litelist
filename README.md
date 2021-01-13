# Litelist

Litelist is an opensource local network shopping portal. It is developed as a local alternative to craigslist and Encuentro24, and can be installed on low resource computers like the Raspberry Pi. It was initially developed by Dhruv Mehrotra and Andrew Gimma as “Othernet” through Mozilla WINS (Wireless Innovation for Network Societies) Challenge grant. It is now currently being developed by SayCel, and is beta-testing on Ole.net, a community network in Olekasasi, Kenya. 

Lite.list is developed using Phoenix and Elixir programming language to provide a scalable, low latency solution for local networks or distributed systems.

### Update from v0.0.1 to v0.1.0

* Remove assets/node_modules from within your existing container
* Run `npm install` within the assets folder, also from within the docker container

### Dependencies

* Docker
* Docker Compose

### Run locally
1. Clone this repo
1. `cd Litelist`
1. `chmod +x run.sh`
1. Make sure ports 4000 and 5432 (postgres) are free. Run `brew services stop postgresql` on Mac.
1. `docker-compose up --build`
1. `docker-compose run web mix test` to run tests.
1. Note that it takes Webpack about 10 seconds to load js and css. We will work to improve this in the future.

### Create first user
1. `docker-compose run web iex -S mix`
1. `import Litelist.Factory`
1. `attrs = %{username: "ADD_NAME_HERE"}` Note: Don't change the password attr. The password will default to 'password'.
1. `insert(:neighbor, attrs)`

### Test authentication
1. Go to localhost:4000 and login with credentials created from above
1. localhost:4000/secret can only be seen by authenticated users

Note: See Docker usage below for more commands.

### Docker usage

Run commands prepended with `docker-compose run web`

`mix ecto.migrate` becomes `docker-compose run web mix ecto.migrate`

`mix ecto.migrate` becomes `docker-compose run web mix ecto.migrate`

### Amnesia database

Amnesia is an elixir wrapper around erlang's Mnesia database.

This database is used for settings because it has a stronger guarantee that it will be read than postgres has. As long as the site is up, the Mnesia SettingsDatabase should be available.

#### Setup

Note: Setup should be automatically handled in run.s

1. `docker-compose run web mix amnesia.create --database Litelist.Settings.SettingsDatabase --disk`

#### Test environment setup

1. `docker-compose run web /bin/bash`
1. `mkdir mnesia`
1. `MIX_ENV=test mix amnesia.create --database Litelist.Settings.SettingsDatabase --disk`

### Some useful commands

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

### Troublehooting

* `docker-compose run web mix deps.update postgrex` If you can't connect to the db
