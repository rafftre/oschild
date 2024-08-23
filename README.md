# Oschild

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
  * Dialyxir: https://github.com/jeremyjh/dialyxir/wiki/Phoenix-Dialyxir-Quickstart

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
