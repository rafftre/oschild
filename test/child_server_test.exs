defmodule ChildServerTest do
  use ExUnit.Case

  alias Child.Core
  alias Child.Server

  @sample_name "Leo"

  test "start server" do
    {:ok, server} = Server.start_link(@sample_name)
    assert Server.current_state(server) == {@sample_name, %Core{activity: :playing}}
  end

  test "current state" do
    {:ok, server} = Server.start_link(@sample_name)

    assert Server.current_state(server) == {@sample_name, %Core{activity: :playing}}

    assert Server.call_to(server, :eat) == {:ok, :eating}
    assert Server.current_state(server) == {@sample_name, %Core{activity: :eating}}

    assert Server.call_to(server, :kindergarten) == {:ok, :hiding}
    assert Server.current_state(server) == {@sample_name, %Core{activity: :hiding}}

    assert Server.call_to(server, :play) == {:ok, :playing}
    assert Server.current_state(server) == {@sample_name, %Core{activity: :playing}}
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

  test "give snacks" do
    {:ok, server} = Server.start_link(@sample_name)

    assert Server.give_snacks(server, 1) == {:ok, 1}

    assert Server.call_to(server, :eat) == {:ok, :eating}
    assert Server.give_snacks(server, 2) == {:ok, 3}

    assert Server.call_to(server, :kindergarten) == {:ok, :hiding}
    assert Server.give_snacks(server, 1) == {:error, 3}
  end
end
