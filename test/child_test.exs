defmodule ChildTest do
  use ExUnit.Case

  test "find children" do
    child_a = Child.find("a")
    child_b = Child.find("b")
    assert child_a != child_b
  end

  test "current activity" do
    child = Child.find("current")

    assert Child.current_activity(child) == :playing

    assert Child.call_to_eat(child) == {:ok, :eating}
    assert Child.current_activity(child) == :eating

    assert Child.call_to_kindergarten(child) == {:ok, :hiding}
    assert Child.current_activity(child) == :hiding

    assert Child.call_to_play(child) == {:ok, :playing}
    assert Child.current_activity(child) == :playing
  end

  test "calls to play" do
    child = Child.find("play")

    assert Child.call_to_play(child) == {:error, :playing}

    assert Child.call_to_eat(child) == {:ok, :eating}
    assert Child.call_to_play(child) == {:ok, :playing}

    assert Child.call_to_kindergarten(child) == {:ok, :hiding}
    assert Child.call_to_play(child) == {:ok, :playing}
  end

  test "calls to eat" do
    child = Child.find("eat")

    assert Child.call_to_eat(child) == {:ok, :eating}

    assert Child.call_to_eat(child) == {:error, :eating}

    assert Child.call_to_kindergarten(child) == {:ok, :hiding}
    assert Child.call_to_eat(child) == {:error, :hiding}
  end

  test "calls to kindergarten" do
    child = Child.find("kindergarten")

    assert Child.call_to_kindergarten(child) == {:ok, :hiding}

    assert Child.call_to_kindergarten(child) == {:ok, :hiding}

    assert Child.call_to_play(child) == {:ok, :playing}
    assert Child.call_to_eat(child) == {:ok, :eating}
    assert Child.call_to_kindergarten(child) == {:ok, :hiding}
  end
end
