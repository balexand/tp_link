defmodule TpLink do
  @moduledoc """
  Documentation for `TpLink`.
  """

  alias TpLink.Cloud.Session
  alias TpLink.Device.CloudDevice

  defdelegate call(device, command), to: TpLink.Device

  def cloud_device(%Session{} = session, device_id) when is_binary(device_id) do
    %CloudDevice{device_id: device_id, session: session}
  end
end
