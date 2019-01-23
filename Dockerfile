FROM elixir:1.6.1-alpine
LABEL maintainer="Nick Janetakis <nick.janetakis@gmail.com>"

RUN apk update && apk add inotify-tools postgresql-dev imagemagick alpine-sdk bash nodejs

WORKDIR /app

COPY mix* ./
RUN mix local.hex --force && mix local.rebar --force \
    && mix deps.get && mix deps.compile

COPY . .
EXPOSE 4000
