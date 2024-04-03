defmodule NannyTest do
  use ExUnit.Case

  alias Child.Supervisor, as: Sup

  @sample_name_1 "Leo"
  @sample_name_2 "Arthur"

  test "start children" do
    Sup.start_link(nil)

    child_1 = Sup.find_child(@sample_name_1)
    child_2 = Sup.find_child(@sample_name_2)
    assert child_1 != child_2
  end
end
