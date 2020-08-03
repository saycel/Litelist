FROM elixir:1.10.4
LABEL maintainer="Germán Martinez github:martizger"

RUN apt-get update -y
RUN apt-get install -y apt-utils
RUN apt-get install -y inotify-tools imagemagick

WORKDIR /app
COPY mix* ./
RUN mix local.hex --force 
RUN mix local.rebar --force
RUN mix deps.get

COPY . .
EXPOSE 4000

ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 14.6.0

RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

RUN . ~/.bashrc \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default