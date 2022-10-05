defmodule NoisyTest do
  use ExUnit.Case
  doctest Noisy

  test "greets the world" do
    assert Noisy.hello() == :world
  end
end
