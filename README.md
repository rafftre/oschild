# Oschild

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).


## Command history

Project Initialization:
```sh
mix phx.new oschild
cd oschild
mix ecto.create
iex -S mix phx.server
```

Code Generation:
```sh
mix phx.gen.live Catalog Product products name:string sku:integer:unique
mix ecto.migrate
```

Dialyzer Setup:
```sh
mix deps.get
mix deps.compile
mix dialyzer --plt
```

Release
```sh
MIX_ENV=prod mix release
mix phx.gen.secret
SECRET_KEY_BASE=changeit _build/prod/rel/oschild/bin/server
```

Docker
```sh
mix phx.gen.release --docker
podman pull docker.io/hexpm/elixir:1.16.3-erlang-24.1.7-debian-bullseye-20240812-slim
podman pull docker.io/debian:bullseye-20240812-slim
podman build -t oschild .
podman run -d -i -e SECRET_KEY_BASE='changeit' -p 4000:4000 oschild
```


## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
  * Dialyxir: https://github.com/jeremyjh/dialyxir/wiki/Phoenix-Dialyxir-Quickstart


## Release

See https://hexdocs.pm/mix/Mix.Tasks.Release.html for more information about
Elixir releases.

Using the generated Dockerfile, your release will be bundled into
a Docker image, ready for deployment on platforms that support Docker.

For more information about deploying with Docker see
https://hexdocs.pm/phoenix/releases.html#containers

Here are some useful release commands you can run in any release environment:
```sh
# To build a release
mix release

# To start your system with the Phoenix server running
_build/dev/rel/oschild/bin/server
```

Once the release is running you can connect to it remotely:
```sh
_build/dev/rel/oschild/bin/oschild remote
```

To list all commands:
```sh
_build/dev/rel/oschild/bin/oschild
```
