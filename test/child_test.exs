defmodule ChildTest do
  use ExUnit.Case

  test "find children" do
    child_a = Child.get("a")
    child_b = Child.get("b")
    assert child_a != child_b

    assert not Enum.empty?(Child.all())
  end

  test "get state" do
    child = Child.get("current")

    assert %{activity: :playing} = Child.get_state(child)

    assert Child.call_to_eat(child) == {:ok, :eating}
    assert %{activity: :eating} = Child.get_state(child)

    assert Child.call_to_kindergarten(child) == {:ok, :hiding}
    assert %{activity: :hiding} = Child.get_state(child)

    assert Child.call_to_play(child) == {:ok, :playing}
    assert %{activity: :playing} = Child.get_state(child)
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

  test "give snacks" do
    child = Child.get("snack")

    assert Child.give_snack(child) == {:ok, 1}

    assert Child.call_to_eat(child) == {:ok, :eating}
    assert Child.give_snack(child) == {:ok, 2}

    assert Child.call_to_kindergarten(child) == {:ok, :hiding}
    assert Child.give_snack(child) == {:error, 2}
  end
end
