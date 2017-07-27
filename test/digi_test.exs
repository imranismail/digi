defmodule DigiTest do
  use ExUnit.Case
  doctest Digi

  test "greets the world" do
    assert Digi.hello() == :world
  end
end
