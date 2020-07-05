defmodule TpLink.MessageTest do
  use ExUnit.Case, async: true

  alias TpLink.Message

  test "decode" do
    assert %{"system" => %{"set_relay_state" => %{"state" => 1}}} ==
             "0PKB+Iv/mvfV75S2xaDUi/mc8JHot8Sw0aXA4tijgfKG55P21O7fot+i"
             |> Base.decode64!()
             |> Message.decode()
  end

  test "encode" do
    assert "0PKB+Iv/mvfV75S2xaDUi/mc8JHot8Sw0aXA4tijgfKG55P21O7fot+i" ==
             %{"system" => %{"set_relay_state" => %{"state" => 1}}}
             |> Message.encode()
             |> Base.encode64()
  end
end
