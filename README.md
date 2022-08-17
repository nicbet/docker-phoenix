# A Containerized Dev Environment for Elixir and the Phoenix Framework

## Introduction

A dockerized development environment to work on [Elixir](https://github.com/elixir-lang/elixir) and [Phoenix](https://github.com/phoenixframework/phoenix) framework projects while keeping the host environment pristine.

### Background

This project was conceived to deal with the issues of running different Elixir and Phoenix versions and supporting the development and maintenance of apps built with different Elixir and Phoenix versions.

Maybe you are working on multiple different projects, built with different versions of the Phoenix framework, or you are working on a long-lived Elixir or Phoenix project. In either case you are likely to hit a version conflict. Phoenix and Elixir are still young und evolving which is great - but some of the changes will likely break your application code. This repository aims to make things easier for you by giving you a straightforward path in swapping out your Elixir and Phoenix environment.

## Getting Started

To initialize a new development environment, clone this repository. You can specify a version tag to target a particular Phoenix framework version. We automatically pin the Elixir version of each release to the version of Elixir that was available at the time of the specific Phoenix framework release.

For instance, to set up a dockerized development environment for a project called `hello-phoenix` using Phoenix framework version `1.6.11` you would run:

```sh
# Clone this repository into a new project folder
git clone -b 1.6.11 https://github.com/nicbet/docker-phoenix ~/Projects/hello-phoenix

# Go to the new project folder
cd ~/Projects/hello-phoenix

# Initialize a new git repository
rm -rf .git
git init
```

## Usage

You can interact with the containerized dev environment in any way that you would usually interact with a container. We've included a handful of covenience scripts to make running common commands and tools inside the container easier from the host environment.

Our recommended path however is to open the cloned repository in VSCode, following the prompts for starting the `devcontainer` environment. This will give you an editor and a terminal inside the container directly from VSCode.

### New Application

To create a completely new application from scratch, you can follow these steps:

1. Navigate the to where you cloned this repository, for example:

   ```
   cd ~/Projects/hello-phoenix
   ```

2. Initialize a new Phoenix application. For example, to create a new Phoenix application called `hello` under the `src/` directory, which is mounted inside the container under `/app` (the default work dir) run:

   ```
   ./mix phx.new . --app hello
   ```

   > Why does this work? The `docker-compose.yml` file inlcuded with this repo maps your local `src/` directory to the `/app` directory inside the container. Inside the container, the `/app` directory is marked as the working directory for any command that is being executed, such as `mix phoenix.new`.

**NOTE:** It is important to specify your app name through the `--app <name>` option, as Phoenix will otherwise name your app from the target directory passed in, which in our case is `.`

**NOTE:** It is okay to answer `Y` when phoenix states that the `/app` directory already exists.

**NOTE:** Starting from 1.3.0 the `mix phoenix.new` command has been deprecated. You will have to use the `phx.new` command instead of `phoenix.new` or `mix deps.get` will fail!

### Existing Application

To use this dev environment with an existing project, follow the steps above to clone this repository and then copy your existing code Phoenix application code to the `<project-name>/src` directory. The `src/` directory won't exist after cloning this repo so you'll have to create it first with `mkdir -p <project-name>/src`.

### Database Connection

The `docker-compose.yml` file included with this repository defines a servicecalled `db` for running a PostgreSQL database that is available to the main application container via the hostname `db`. By default Phoenix assumes that you are running a database locally. In order to use the `db` service with your application you will need to modify your Phoenix config and point `Ecto` to the database host.

Modify the Ecto configuration `src/config/dev.exs` to point to the DB container:

```elixir
# Configure your database
config :test, Test.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "test_dev",
  hostname: "db",
  pool_size: 10
```

#### Initialize the Database

When you first start out, the `db` service will contain no databases. To initialize a database for your project, you can run the included convenience script from your host environment:

```sh
./mix ecto.create
```

Then, run your database migrations:

```
./mix ecto.migrate
```

If you are working inside the dev environment (i.e., using the devcontainer terminal from VSCode), skip the `./` in front of the commands.

### Starting the Application

To start you application in development mode you will first need to change your Phoenix configuration to bind the `phx.server` to `0.0.0.0`, so that the container exposes the `phx.server` to the host network.

To bind the `phx.server` to all interfaces, edit your `config/dev.exs` file and set the endpoint listen address to `0.0.0.0`:

```elixir
config :hello_world, HelloWorldWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  ...
```

you can run the following command from your host environment:

```sh
docker-compose up
```

Alternatively, if you just want to run the Phoenix application server you can execute:

```sh
./mix phx.server
```

Once booted, it will be available under http://localhost:4000.

## Notes

### Custom commands

To run any command inside the dev container, you can use the `./run` script and pass the command and its arguments.

```sh
./run iex -S mix
```

## Building the image for your platform

You can locally build the container image with the included Makefile:

```sh
make docker-image
```

## Support for VS Code Remote Extension

After cloning this repository, open the folder in Visual Studio Code's Remote Extension to get a full Development Environment (with PostgreSQL Database) spun up automatically.

See [https://code.visualstudio.com/docs/remote/containers](https://code.visualstudio.com/docs/remote/containers) for more details.

## Releases with Elixir 1.9+

To prepare a minimal Docker release image based on Alpine Linux (about 38MB for a Phoenix Webapp) you can follow this [Github Gist](https://gist.github.com/nicbet/102f16359828405ce34ca083976986e1).
