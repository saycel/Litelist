FROM bitwalker/alpine-elixir-phoenix:1.8.0

# Set exposed ports
EXPOSE 4000
# ENV PORT=5000 MIX_ENV=prod
RUN apk update && apk add imagemagick
# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# Same with npm deps
ADD assets/package.json assets/
RUN cd assets && \
    npm install

ADD . .

# Run frontend build, compile, and digest assets
RUN cd assets/ && \
    npm run deploy && \
    cd - && \
    mix do compile, phx.digest


CMD ["mix", "phx.server"]