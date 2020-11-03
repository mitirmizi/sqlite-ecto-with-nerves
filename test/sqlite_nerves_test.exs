defmodule SqliteNervesTest do
  use ExUnit.Case
  doctest SqliteNerves

  test "greets the world" do
    assert SqliteNerves.hello() == :world
  end
end
