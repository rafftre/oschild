defmodule ChildLogicTest do
  use ExUnit.Case

  alias Child.Logic, as: Child

  test "just woken up" do
    assert Child.wake_up() == %Child{state: :playing}
  end

  test "playing transitions" do
    playing = Child.wake_up()
    assert playing == %Child{state: :playing}

    assert Child.call_to!(playing, :eat) == %Child{state: :eating}
    assert Child.call_to!(playing, :kindergarten) == %Child{state: :hiding}
    assert_raise RuntimeError, fn -> Child.call_to!(playing, :play) end
  end

  test "eating transitions" do
    eating = Child.wake_up() |> Child.call_to!(:eat)
    assert eating == %Child{state: :eating}

    assert Child.call_to!(eating, :play) == %Child{state: :playing}
    assert Child.call_to!(eating, :kindergarten) == %Child{state: :hiding}
    assert_raise RuntimeError, fn -> Child.call_to!(eating, :eat) end
  end

  test "hiding transitions" do
    hiding = Child.wake_up() |> Child.call_to!(:kindergarten)
    assert hiding == %Child{state: :hiding}

    assert Child.call_to!(hiding, :play) == %Child{state: :playing}
    assert Child.call_to!(hiding, :kindergarten) == %Child{state: :hiding}
    assert_raise RuntimeError, fn -> Child.call_to!(hiding, :eat) end
  end

  test "invalid calls" do
    playing = Child.wake_up()
    assert playing == %Child{state: :playing}

    assert_raise FunctionClauseError, fn -> Child.call_to!("aaa", :eat) end
    assert_raise FunctionClauseError, fn -> Child.call_to!(1, :eat) end
    assert_raise FunctionClauseError, fn -> Child.call_to!(false, :eat) end
    assert_raise FunctionClauseError, fn -> Child.call_to!(nil, :eat) end

    assert_raise RuntimeError, fn -> Child.call_to!(playing, "aaa") end
    assert_raise RuntimeError, fn -> Child.call_to!(playing, 1) end
    assert_raise RuntimeError, fn -> Child.call_to!(playing, false) end
    assert_raise RuntimeError, fn -> Child.call_to!(playing, nil) end
  end
end
