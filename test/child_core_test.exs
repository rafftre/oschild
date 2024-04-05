defmodule ChildCoreTest do
  use ExUnit.Case

  alias Child.Core

  test "just woken up" do
    assert Core.wake_up() == %Core{activity: :playing}
  end

  test "playing transitions" do
    playing = Core.wake_up()
    assert playing == %Core{activity: :playing}

    assert Core.call_to!(playing, :eat) == %Core{activity: :eating}
    assert Core.call_to!(playing, :kindergarten) == %Core{activity: :hiding}
    assert_raise RuntimeError, fn -> Core.call_to!(playing, :play) end
  end

  test "eating transitions" do
    eating = Core.wake_up() |> Core.call_to!(:eat)
    assert eating == %Core{activity: :eating}

    assert Core.call_to!(eating, :play) == %Core{activity: :playing}
    assert Core.call_to!(eating, :kindergarten) == %Core{activity: :hiding}
    assert_raise RuntimeError, fn -> Core.call_to!(eating, :eat) end
  end

  test "hiding transitions" do
    hiding = Core.wake_up() |> Core.call_to!(:kindergarten)
    assert hiding == %Core{activity: :hiding}

    assert Core.call_to!(hiding, :play) == %Core{activity: :playing}
    assert Core.call_to!(hiding, :kindergarten) == %Core{activity: :hiding}
    assert_raise RuntimeError, fn -> Core.call_to!(hiding, :eat) end
  end

  test "invalid call_tos" do
    playing = Core.wake_up()
    assert playing == %Core{activity: :playing}

    assert_raise FunctionClauseError, fn -> Core.call_to!("aaa", :eat) end
    assert_raise FunctionClauseError, fn -> Core.call_to!(%{}, :eat) end
    assert_raise FunctionClauseError, fn -> Core.call_to!(1, :eat) end
    assert_raise FunctionClauseError, fn -> Core.call_to!(false, :eat) end
    assert_raise FunctionClauseError, fn -> Core.call_to!(nil, :eat) end

    assert_raise RuntimeError, fn -> Core.call_to!(playing, "aaa") end
    assert_raise RuntimeError, fn -> Core.call_to!(playing, 1) end
    assert_raise RuntimeError, fn -> Core.call_to!(playing, false) end
    assert_raise RuntimeError, fn -> Core.call_to!(playing, nil) end
  end

  test "give snacks" do
    child = Core.wake_up()
    assert child == %Core{activity: :playing}

    child = Core.give_snacks(child, 1)
    assert child == %Core{snacks: 1, activity: :playing}

    child = child |> Core.call_to!(:eat) |> Core.give_snacks(2)
    assert child == %Core{snacks: 3, activity: :eating}

    child = child |> Core.call_to!(:kindergarten) |> Core.give_snacks(1)
    assert child == %Core{snacks: 3, activity: :hiding}

    child = Core.call_to!(child, :play)
    assert Core.give_snacks(child, 0) == %Core{snacks: 3}
    assert Core.give_snacks(child, -1) == %Core{snacks: 3}
    assert Core.give_snacks(child, "aaa") == %Core{snacks: 3}
    assert Core.give_snacks(child, false) == %Core{snacks: 3}
    assert Core.give_snacks(child, nil) == %Core{snacks: 3}

    assert_raise FunctionClauseError, fn -> Core.give_snacks("aaa", 1) end
    assert_raise FunctionClauseError, fn -> Core.give_snacks(%{}, 1) end
    assert_raise FunctionClauseError, fn -> Core.give_snacks(1, 1) end
    assert_raise FunctionClauseError, fn -> Core.give_snacks(false, 1) end
    assert_raise FunctionClauseError, fn -> Core.give_snacks(nil, 1) end
  end

  test "consume snacks" do
    child = Core.wake_up()
    assert child == %Core{activity: :playing, mood: 0, snacks: 0}

    child = child |> Core.call_to!(:eat) |> Core.give_snacks(18)
    assert child == %Core{activity: :eating, mood: 0, snacks: 18}

    child = Core.call_to!(child, :play)
    assert child == %Core{activity: :playing, mood: 29, snacks: 0}

    child = child |> Core.call_to!(:kindergarten)
    assert child == %Core{activity: :hiding, mood: 0, snacks: 0}
  end
end
