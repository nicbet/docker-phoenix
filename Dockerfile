FROM elixir:1.11.2
MAINTAINER Nicolas Bettenburg <nicbet@gmail.com>

RUN mix local.hex --force \
  && mix archive.install --force hex phx_new 1.5.7 \
  && apt-get update \
  && curl -sL https://deb.nodesource.com/setup_12.x | bash \
  && apt-get install -y apt-utils \
  && apt-get install -y nodejs \
  && apt-get install -y build-essential \
  && apt-get install -y inotify-tools \
  && apt-get install -y ruby \
  && gem install htmlbeautifier \
  && mix local.rebar --force

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

EXPOSE 4000

CMD ["mix", "phx.server"]
