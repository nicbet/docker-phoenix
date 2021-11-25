FROM elixir:1.12.3

# Apt
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apt-utils
RUN apt-get install -y build-essential
RUN apt-get install -y inotify-tools

# Nodejs
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash
RUN apt-get install -y nodejs

# Phoenix
RUN mix local.hex --force
RUN mix archive.install --force hex phx_new 1.6.2
RUN mix local.rebar --force

# App Directory
ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# App Port
EXPOSE 4000

# Default Command
CMD ["mix", "phx.server"]
