# A Containerized Dev Environment for Elixir and the Phoenix Framework

## Introduction

A dockerized development environment to work on [Elixir](https://github.com/elixir-lang/elixir) and [Phoenix](https://github.com/phoenixframework/phoenix) framework projects while keeping the host environment pristine.

This project was conceived to deal with the issues of running different Elixir and Phoenix versions and supporting the development and maintenance of apps built with different Elixir and Phoenix versions.

Maybe you are working on multiple different projects, built with different versions of the Phoenix framework, or you are working on a long-lived Elixir or Phoenix project. In either case you are likely to hit a version conflict. Phoenix and Elixir are still young and evolving which is great - but some of the changes will likely break your application code. This repository aims to make things easier for you by giving you a straightforward path in swapping out your Elixir and Phoenix environment.

## Notable Changes

- **Switch to Bullseye base image**
  This is a potentially breaking change if you are using this image / repository as a base for your own customized images. We're switching from the upstream **Alpine** images to **Debian Bullseye** images, since most build tools and libraries, as well as the Erlang documentation are not included in the Alpine stream. Since the primary focus of this repository is to give developers easy access to the entire toolchain to build their Elixir/Phoenix applications with minimal requirements on the host, and as much of an optimal out-of-the-box dev experience with VSCode, we've decided that we'd rather have full toolchains and documentation over smaller image sizes.

- **Docker Phoenix 1.7.10 **
  The default database for the `compose` stack and `devcontainer` is now PostgreSQL 16

- **Docker Phoenix 1.7.5**
  The image now includes the `build-base` package by default to support compile-time dependencies like `bcrypt` for `mix phx.gen.auth`

- **#1d570c14007b7750da776e0b6bd2b7568ec67de5**
  We've switched the default branch of the repository from `master` to `main`. Please update your local repository refs!

- **Docker Phoenix 1.6.15**
  We are currently in the process of switching to `Alpine Linux` based images, which are significantly smaller (~150MB vs 1.7GB). Expect the next release to make `-alpine` the new default for the dev environments. As a result, you will need to rebuild your VSCode dev containers and your application code.

- **Docker Phoenix 1.6.13**
  Starting with this version, we've switched the Docker image hosted at Docker Hub (`docker pull nicbet/phoenix:1.6.13`) to M1 Mac, i.e., `linux/arm64/v8` architecture. If you are developing on an Intel machine, you will need to build the docker image on your platform to get started run `make docker-image`.

## Getting Started

As of December 2022, we recommend using the [Visual Studio Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers) approach over the command line. See below for details.

### Visual Studio Code (Dev Containers)

#### Setting up a brand-new project

If you are using a recent version of [Visual Studio Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers), we highly recommend going this route for a much improved development experience out of the box.

1. Use [Degit](https://github.com/Rich-Harris/degit) to quickly clone this project as a scaffold for your new project, for example an app called `hello_world`.

   ```css
   npx degit nicbet/docker-phoenix#1.7.12 hello_world
   ```

2. Open the `hello_world` folder in Visual Studio Code

3. When asked, select `Reopen in container`. Visual Studio code will create a complete application stack including a PostgreSQL database, and mount your local `./app` folder as the root folder for the development environment.

4. After initialization of your dev environment finishes, open the `Terminal` tab in Visual Studio Code.

5. Create your new Phoenix application with the following command (**note the `.`**!):

   ```bash
   mix phx.new . hello_world
   ```

6. As the mix command runs, you will see your Visual Studio Code file explorer populate with the files of your new phoenix app. All these files are available outside your development environment in the `./app` folder.

**Note:** You don't need to use `degit`. Alternatively, you can clone this repository and remove the `.git` folder manually.

#### Configuring the Database Connection

Both, the docker-compose stack started with the `docker-compose.yml` file included with this repository and the Visual Studio Code Dev Containers stack define a service called `db` for running a PostgreSQL database that is available to the main application container via the hostname `db`. By default Phoenix assumes that you are running a database locally. In order to use the `db` service with your application you will need to modify your Phoenix config and point `Ecto` to the database host.

To use the included database with your phoenix application you will need to modify the Ecto configuration `config/dev.exs` and point it to the DB container:

```elixir
# Configure your database
config :test, Test.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: "db",
  username: "postgres",
  password: "postgres",
  # ...
  pool_size: 10
```

#### Running your Application

To start you application in development mode you will first need to change your Phoenix configuration to bind the `phx.server` to `0.0.0.0`, so that the container exposes the `phx.server` to the host network.

To bind the `phx.server` to all interfaces, edit your `config/dev.exs` file and set the endpoint listen address to `0.0.0.0`:

```elixir
config :hello_world, HelloWorldWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  ...
```

From the VSCode terminal you can run the Phoenix application server with:

```sh
mix phx.server
```

Once the startup is completed, your app will be available at http://localhost:4000

### Using the Command Line instead of Dev Containers

After cloning the repository, you can use the included `./run`, `./mix`, `./npm`, and `./yarn` scripts to execute commands in the development environment described by included `docker-compose.yml` file. For instance, running `./mix phx.new . hello_world` would generate a new phoenix application called `hello_world`. Similarly to the Visual Studio Code Dev Containers approach, your project files will be locally stored in the `./app` container which is mounted to `/app` inside the development environment.

The instructions for changing the database connection and bind address as described above apply here as well.

To run any command inside the dev container, you can use the `./run` script and pass the command and its arguments.

```sh
./run iex -S mix
```

## Building the image for your platform

You can locally build the container image with the included Makefile:

```sh
make docker-image
```

## Usage with an existing project

You can use this project to dockerize the development enviroment for an existing project. Follow the steps above, but instead of initializing a new application with `mix phx.new`, copy your existing project code to the `./app` subdirectory. This will make your existing code available in the dockerized dev environment.

## Contributing

This project is intended to be a safe, welcoming space for collaboration. Contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. We recommend reading the [contributing guide](./docs/CONTRIBUTING.md) as well.

## License

Docker Phoenix is available as open source under the terms of the [GNU Public License v3](https://www.gnu.org/licenses/gpl-3.0.en.html).

## Contributors

Docker Phoenix is built by members of the Open Source community, including:

<img src="https://avatars.githubusercontent.com/apenney?s=64" alt="apenney" width="32" />, <img src="https://avatars.githubusercontent.com/cruisemaniac?s=64" alt="cruisemaniac" width="32" />, <img src="https://avatars.githubusercontent.com/homanchou?s=64" alt="homanchou" width="32"/>, <img src="https://avatars.githubusercontent.com/tmr08c?s=64" alt="tmr08c" width="32" />, <img src="https://avatars.githubusercontent.com/jacknoble?s=64" alt="jacknoble" width="32" />, <img src="https://avatars.githubusercontent.com/ravloony?s=64" alt="ravloony" width="32" />, <img src="https://avatars.githubusercontent.com/asifaly?s=64" alt="asifaly" width="32" /> ,<img src="https://avatars.githubusercontent.com/ajmeese7?s=64" alt="ajmeese7" width="32" />, <img src="https://avatars.githubusercontent.com/restlessronin?s=64" alt="restlessronin" width="32" />
