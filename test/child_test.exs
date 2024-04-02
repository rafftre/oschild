defmodule ChildTest do
  use ExUnit.Case
  doctest Child

  test "greets the world" do
    assert Child.hello() == :world
  end
end
