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
RUN \
curl -sfLO http://www.imagemagick.org/download/ImageMagick-6.9.9-40.tar.gz && \
tar -xzf ImageMagick-6.9.9-40.tar.gz && \
cd ImageMagick-6.9.9-40 && \
./configure --prefix /usr/local && \
make install && \
cd .. && \
rm -rf ImageMagick*

WORKDIR /app
EXPOSE 4000
