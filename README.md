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
1. `docker-compose up`
1. Go to localhost:4000
1. `docker-compose run web mix test` to run tests.

### Create first user
1. `docker-compose run web iex -S mix` Note: `iex -S mix` is like running `rails console`
1. `Litelist.Auth.create_neighbor(%{username: "ADD_NAME_HERE", password: "ADD_PASSWORD_HERE"})`

### Or Create user with factories
1. `docker-compose run web iex -S mix`
1. `import Litelist.Factory`
1. `attrs = %{username: 'ADD_NAME_HERE', password: 'ADD_PASSWORD_HERE'}`
1. `build(:neighbor, attrs)`

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

Some useful commands

* `docker-compose run web mix ecto.rollback`
* `docker-compose run web mix ecto.migrate`
* `docker-compose run web mix test`
* `docker-compose run web /bin/bash`