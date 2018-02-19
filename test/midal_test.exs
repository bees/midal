defmodule MidalTest do
  use ExUnit.Case
  doctest Midal

  test "does thing" do
    assert Midal.parse!("") == :world
  end
end
