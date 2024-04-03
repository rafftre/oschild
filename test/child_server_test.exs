defmodule ChildServerTest do
  use ExUnit.Case

  alias Child.Server

  @sample_name "Leo"

  test "start server" do
    {:ok, server} = Server.start_link(@sample_name)
    assert Server.current_activity(server) == :playing
  end

  test "current activity" do
    {:ok, server} = Server.start_link(@sample_name)

    assert Server.current_activity(server) == :playing

    assert Server.call_to_eat(server) == {:ok, :eating}
    assert Server.current_activity(server) == :eating

    assert Server.call_to_kindergarten(server) == {:ok, :hiding}
    assert Server.current_activity(server) == :hiding

    assert Server.call_to_play(server) == {:ok, :playing}
    assert Server.current_activity(server) == :playing
  end

  test "calls to play" do
    {:ok, server} = Server.start_link(@sample_name)

    assert Server.call_to_play(server) == {:error, :playing}

    assert Server.call_to_eat(server) == {:ok, :eating}
    assert Server.call_to_play(server) == {:ok, :playing}

    assert Server.call_to_kindergarten(server) == {:ok, :hiding}
    assert Server.call_to_play(server) == {:ok, :playing}
  end

  test "calls to eat" do
    {:ok, server} = Server.start_link(@sample_name)

    assert Server.call_to_eat(server) == {:ok, :eating}

    assert Server.call_to_eat(server) == {:error, :eating}

    assert Server.call_to_kindergarten(server) == {:ok, :hiding}
    assert Server.call_to_eat(server) == {:error, :hiding}
  end

  test "calls to kindergarten" do
    {:ok, server} = Server.start_link(@sample_name)

    assert Server.call_to_kindergarten(server) == {:ok, :hiding}

    assert Server.call_to_kindergarten(server) == {:ok, :hiding}

    assert Server.call_to_play(server) == {:ok, :playing}
    assert Server.call_to_eat(server) == {:ok, :eating}
    assert Server.call_to_kindergarten(server) == {:ok, :hiding}
  end
end
