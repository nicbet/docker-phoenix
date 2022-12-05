FROM elixir:1.14.1

# Build Args
ARG PHOENIX_VERSION=1.6.14
ARG NODEJS_VERSION=18.x

# Apt
RUN apt-get update && apt-get upgrade -y && apt-get install -y apt-utils build-essential inotify-tools

# Nodejs
RUN curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION} | bash
RUN apt-get install -y nodejs

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
