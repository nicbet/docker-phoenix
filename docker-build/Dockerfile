FROM elixir:1.12.3
LABEL maintainer="Nicolas Bettenburg <nicbet@gmail.com>"

ARG PHOENIX_VERSION=1.6.2
ARG NODEJS_VERSION=12.x

RUN mix local.hex --force \
  && mix archive.install --force hex phx_new ${PHOENIX_VERSION} \
  && apt-get update \
  && curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION} | bash \
  && apt-get install -y apt-utils \
  && apt-get install -y nodejs \
  && apt-get install -y build-essential \
  && apt-get install -y inotify-tools \
  && mix local.rebar --force

EXPOSE 4000
