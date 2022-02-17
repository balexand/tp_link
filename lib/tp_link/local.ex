defmodule TpLink.Local do
  @moduledoc """
  For working with devices directly on the local network. Functions in this module will only work
  when called on a device that is connected to the same local network as the TP-Link devices.
  """

  alias TpLink.Local.DiscoveryServer

  @list_devices_options_schema [
    timeout: [
      default: 2_500,
      doc: "Duration in milliseconds to wait for responses.",
      type: :pos_integer
    ]
  ]

  @doc """
  Returns a list of devices on the local network. See `TpLink.Local.DiscoveryServer` for details.

  ## Options

  #{NimbleOptions.docs(@list_devices_options_schema)}

  """
  def list_devices(opts \\ []) do
    opts = NimbleOptions.validate!(opts, @list_devices_options_schema)
    timeout = Keyword.fetch!(opts, :timeout)

    {:ok, pid} = DiscoveryServer.start_link()

    :timer.sleep(timeout)
    devices = DiscoveryServer.list_devices(pid)

    :ok = DiscoveryServer.stop(pid)

    devices
  end
end
