FROM elixir:1.14.5-alpine

# Build Args
ARG PHOENIX_VERSION=1.7.5

# Apk
RUN apk add bash build-base git inotify-tools nodejs-current npm yarn

# Phoenix
RUN mix local.hex --force
RUN mix archive.install --force hex phx_new #{PHOENIX_VERSION}
RUN mix local.rebar --force

# App Directory
ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# App Port
EXPOSE 4000

# Default Command
CMD ["mix", "phx.server"]
