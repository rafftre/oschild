defmodule ChildServerTest do
  use ExUnit.Case
  doctest ChildServer

  test "start server" do
    {:ok, server} = ChildServer.start_link()
    assert ChildServer.current_activity(server) == :playing
  end

  test "current activity" do
    {:ok, server} = ChildServer.start_link()

    assert ChildServer.current_activity(server) == :playing

    assert ChildServer.call_to_eat(server) == {:ok, :eating}
    assert ChildServer.current_activity(server) == :eating

    assert ChildServer.call_to_kindergarten(server) == {:ok, :hiding}
    assert ChildServer.current_activity(server) == :hiding

    assert ChildServer.call_to_play(server) == {:ok, :playing}
    assert ChildServer.current_activity(server) == :playing
  end

  test "calls to play" do
    {:ok, server} = ChildServer.start_link()

    assert ChildServer.call_to_play(server) == {:error, :playing}

    assert ChildServer.call_to_eat(server) == {:ok, :eating}
    assert ChildServer.call_to_play(server) == {:ok, :playing}

    assert ChildServer.call_to_kindergarten(server) == {:ok, :hiding}
    assert ChildServer.call_to_play(server) == {:ok, :playing}
  end

  test "calls to eat" do
    {:ok, server} = ChildServer.start_link()

    assert ChildServer.call_to_eat(server) == {:ok, :eating}

    assert ChildServer.call_to_eat(server) == {:error, :eating}

    assert ChildServer.call_to_kindergarten(server) == {:ok, :hiding}
    assert ChildServer.call_to_eat(server) == {:error, :hiding}
  end

  test "calls to kindergarten" do
    {:ok, server} = ChildServer.start_link()

    assert ChildServer.call_to_kindergarten(server) == {:ok, :hiding}

    assert ChildServer.call_to_kindergarten(server) == {:ok, :hiding}

    assert ChildServer.call_to_play(server) == {:ok, :playing}
    assert ChildServer.call_to_eat(server) == {:ok, :eating}
    assert ChildServer.call_to_kindergarten(server) == {:ok, :hiding}
  end
end
