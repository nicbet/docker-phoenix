FROM elixir:1.4.5
MAINTAINER Nicolas Bettenburg <nicbet@gmail.com>

RUN mix local.hex --force \
 && mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phoenix_new-1.2.4.ez \
 && apt-get update \
 && curl -sL https://deb.nodesource.com/setup_6.x | bash \
 && apt-get install -y nodejs \
 && apt-get install -y build-essential \
 && apt-get install -y inotify-tools \
 && mix local.rebar --force

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

EXPOSE 4000

CMD ["mix", "phoenix.server"]
