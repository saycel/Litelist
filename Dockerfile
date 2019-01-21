FROM elixir:1.6.1-alpine
LABEL maintainer="Nick Janetakis <nick.janetakis@gmail.com>"

RUN apk update && apk add inotify-tools postgresql-dev imagemagick alpine-sdk bash

WORKDIR /app

COPY mix* ./
RUN mix local.hex --force && mix local.rebar --force \
    && mix deps.get && mix deps.compile
    
COPY . .

# RUN mix ecto.create && mix ecto.migrate

EXPOSE 4000
# HEALTHCHECK CMD wget -q -O /dev/null http://localhost:4000/healthy || exit 1

# CMD ["mix", "phx.server"]