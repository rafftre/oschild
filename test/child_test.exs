defmodule ChildTest do
  use ExUnit.Case

  test "find children" do
    child_a = Child.get("a")
    child_b = Child.get("b")
    assert child_a != child_b

    assert not Enum.empty?(Child.all())
  end

  test "current activity" do
    child = Child.get("current")

    assert Child.current_activity(child) == :playing

    assert Child.call_to_eat(child) == {:ok, :eating}
    assert Child.current_activity(child) == :eating

    assert Child.call_to_kindergarten(child) == {:ok, :hiding}
    assert Child.current_activity(child) == :hiding

    assert Child.call_to_play(child) == {:ok, :playing}
    assert Child.current_activity(child) == :playing
  end

  test "calls to play" do
    child = Child.get("play")

    assert Child.call_to_play(child) == {:error, :playing}

    assert Child.call_to_eat(child) == {:ok, :eating}
    assert Child.call_to_play(child) == {:ok, :playing}

    assert Child.call_to_kindergarten(child) == {:ok, :hiding}
    assert Child.call_to_play(child) == {:ok, :playing}
  end

  test "calls to eat" do
    child = Child.get("eat")

    assert Child.call_to_eat(child) == {:ok, :eating}

    assert Child.call_to_eat(child) == {:error, :eating}

    assert Child.call_to_kindergarten(child) == {:ok, :hiding}
    assert Child.call_to_eat(child) == {:error, :hiding}
  end

  test "calls to kindergarten" do
    child = Child.get("kindergarten")

    assert Child.call_to_kindergarten(child) == {:ok, :hiding}

    assert Child.call_to_kindergarten(child) == {:ok, :hiding}

    assert Child.call_to_play(child) == {:ok, :playing}
    assert Child.call_to_eat(child) == {:ok, :eating}
    assert Child.call_to_kindergarten(child) == {:ok, :hiding}
  end
end
