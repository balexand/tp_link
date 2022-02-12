defmodule TpLinkTest do
  use ExUnit.Case, async: true
  doctest TpLink, import: true

  test "greets the world" do
    assert TpLink.hello() == :world
  end
end
