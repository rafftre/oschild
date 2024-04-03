defmodule ChildSupervisorTest do
  use ExUnit.Case

  alias Child.Supervisor, as: Sup

  test "start children" do
    Sup.start_link(nil)

    child_a = Sup.find_child("a")
    child_b = Sup.find_child("b")
    assert child_a != child_b
  end
end
