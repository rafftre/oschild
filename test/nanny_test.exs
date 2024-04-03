defmodule NannyTest do
  use ExUnit.Case
  doctest Nanny

  @sample_name_1 "Leo"
  @sample_name_2 "Arthur"

  test "start children" do
    Nanny.start_link(nil)

    child_1 = Nanny.find_child(@sample_name_1)
    child_2 = Nanny.find_child(@sample_name_2)
    assert child_1 != child_2

    assert ChildServer.current_activity(child_1) == ChildServer.current_activity(child_2)

    {:ok, child_1_state} = ChildServer.call_to_eat(child_1)
    {:ok, child_2_state} = ChildServer.call_to_kindergarten(child_2)
    assert child_1_state != child_2_state
  end
end
