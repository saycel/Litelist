# Litelist

### Dependencies

* Docker
* Docker Compose

### Run locally
1. Clone this repo
1. `cd Litelist`
1. `chmod +x run.sh`
1. `docker-compose build` # You only need to run this the first time
1. `docker-compose up`

### Current Issues
* Inconsistent live-reload while using Docker.

### Steps to recreate this repo
1. `mix phx.new litelist`
1. Set up Dockerfile, docker-compose.yml and run.sh.
1. Start from the Run Locally section above.
