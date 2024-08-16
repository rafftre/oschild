defmodule Oschild.Repo do
  use Ecto.Repo,
    otp_app: :oschild,
    adapter: Ecto.Adapters.Postgres
end
