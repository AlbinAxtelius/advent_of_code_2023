defmodule AdventOfCodeTest do
  use ExUnit.Case
  doctest Advent

  test "greets the world" do
    assert AdventOfCode.hello() == :world
  end
end
