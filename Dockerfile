FROM elixir:1.13.1

# Build Args
ARG PHOENIX_VERSION=1.6.6
ARG NODEJS_VERSION=16.x

# Apt
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apt-utils
RUN apt-get install -y build-essential
RUN apt-get install -y inotify-tools

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
