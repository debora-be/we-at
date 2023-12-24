defmodule WeAtTest do
  use ExUnit.Case
  doctest WeAt

  test "greets the world" do
    assert WeAt.hello() == :world
  end
end
