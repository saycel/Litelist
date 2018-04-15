# Elixir + Phoenix

FROM elixir:1.6.1
# Install debian packages
RUN apt-get update
RUN apt-get install --yes tar xz-utils build-essential inotify-tools postgresql-client gcc mono-mcs && rm -rf /var/lib/apt/lists/*
# Install Phoenix packages
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

# Install NodeJS and the NPM
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y -q nodejs

# Install ImageMagick
RUN apt-get install imagemagick

WORKDIR /app
EXPOSE 4000
