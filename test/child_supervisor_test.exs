defmodule ChildSupervisorTest do
  use ExUnit.Case

  alias Child.Supervisor, as: Sup

  test "start children" do
    Sup.start_link(nil)

    child_a = Sup.get_child("a")
    child_b = Sup.get_child("b")
    assert child_a != child_b

    assert not Enum.empty?(Sup.find_all())
  end
end
