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
* `docker-compose run web mix coveralls`