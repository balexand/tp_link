defmodule TpLink do
  @moduledoc """
  Documentation for `TpLink`.
  """

  alias TpLink.Cloud.{CloudDevice, Session}
  alias TpLink.Local.LocalDevice

  defdelegate call(device, command), to: TpLink.Device

  @doc """
  Creates a device struct for a device that is accessed through the cloud.
  """
  def cloud_device(%Session{} = session, device_id) when is_binary(device_id) do
    %CloudDevice{device_id: device_id, session: session}
  end

  @doc """
  Create a device struct for a device that is accessed via the local Wifi network. `host` should
  be an IP address or hostname in a format accepted by Erlang.

  ## Options

    * `timeout` - Timeout in ms (default 5000)
  """
  def local_device(host, opts \\ []) do
    opts = Keyword.validate!(opts, timeout: 5000)
    %LocalDevice{host: host, opts: opts}
  end
end
