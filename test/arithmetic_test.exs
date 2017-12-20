defmodule ArithmeticTest do
  use ExUnit.Case
  doctest Arithmetic

  test "greets the world" do
    assert Arithmetic.hello() == :world
  end
end
