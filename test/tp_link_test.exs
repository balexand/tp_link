defmodule TpLinkTest do
  use ExUnit.Case, async: true
  doctest TpLink, import: true

  test "cloud_device" do
    assert TpLink.cloud_device(%TpLink.Cloud.Session{token: "t", uuid: "u"}, "device-1") ==
             %TpLink.Cloud.CloudDevice{
               device_id: "device-1",
               session: %TpLink.Cloud.Session{token: "t", uuid: "u"}
             }
  end

  test "local_device" do
    assert TpLink.local_device({192, 168, 0, 10}) == %TpLink.Local.LocalDevice{
             host: {192, 168, 0, 10},
             opts: [timeout: 5000]
           }
  end
end
