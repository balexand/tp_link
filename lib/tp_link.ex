defmodule TpLink do
  @moduledoc """
  Documentation for `TpLink`.
  """

  alias TpLink.Cloud.Session
  alias TpLink.Device.CloudDevice

  defdelegate call(device, command), to: TpLink.Device

  @doc """
  Creates a device struct for a device that is accessed through the cloud.
  """
  def cloud_device(%Session{} = session, device_id) when is_binary(device_id) do
    %CloudDevice{device_id: device_id, session: session}
  end
end
