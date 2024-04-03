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

    assert Server.call_to(server, :eat) == {:ok, :eating}
    assert Server.current_activity(server) == :eating

    assert Server.call_to(server, :kindergarten) == {:ok, :hiding}
    assert Server.current_activity(server) == :hiding

    assert Server.call_to(server, :play) == {:ok, :playing}
    assert Server.current_activity(server) == :playing
  end

  test "calls to play" do
    {:ok, server} = Server.start_link(@sample_name)

    assert Server.call_to(server, :play) == {:error, :playing}

    assert Server.call_to(server, :eat) == {:ok, :eating}
    assert Server.call_to(server, :play) == {:ok, :playing}

    assert Server.call_to(server, :kindergarten) == {:ok, :hiding}
    assert Server.call_to(server, :play) == {:ok, :playing}
  end

  test "calls to eat" do
    {:ok, server} = Server.start_link(@sample_name)

    assert Server.call_to(server, :eat) == {:ok, :eating}

    assert Server.call_to(server, :eat) == {:error, :eating}

    assert Server.call_to(server, :kindergarten) == {:ok, :hiding}
    assert Server.call_to(server, :eat) == {:error, :hiding}
  end

  test "calls to kindergarten" do
    {:ok, server} = Server.start_link(@sample_name)

    assert Server.call_to(server, :kindergarten) == {:ok, :hiding}

    assert Server.call_to(server, :kindergarten) == {:ok, :hiding}

    assert Server.call_to(server, :play) == {:ok, :playing}
    assert Server.call_to(server, :eat) == {:ok, :eating}
    assert Server.call_to(server, :kindergarten) == {:ok, :hiding}
  end
end
