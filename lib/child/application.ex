defmodule Child.Application do
  use Application

  def start(_type, _args) do
    Child.Supervisor.start_link(nil)
  end
end
