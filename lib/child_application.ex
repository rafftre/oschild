defmodule ChildApplication do
  use Application

  def start(_type, _args) do
    Nanny.start_link(nil)
  end
end
