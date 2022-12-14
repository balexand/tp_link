defmodule TpLink do
  @moduledoc """
  Client library for interacting with Kasa/TP-Link smart home devices via either tplinkcloud.com or
  directly over the local network. See the [README](README.md) for examples.
  """

  alias TpLink.Cloud.{CloudDevice, Session}
  alias TpLink.Local.LocalDevice

  @doc """
  Sends a command to a device and returns the response. Use `cloud_device/2` or `local_device/2`
  to generate a device struct.
  """
  defdelegate call(device, command), to: TpLink.Device

  @doc """
  Creates a device struct for a device that is accessed through the cloud. Generate a session with
  `TpLink.Cloud.login/2`.
  """
  def cloud_device(%Session{} = session, device_id) when is_binary(device_id) do
    %CloudDevice{device_id: device_id, session: session}
  end

  @local_device_options_schema [
    timeout: [
      default: 5_000,
      doc: "Timeout in milliseconds.",
      type: :pos_integer
    ]
  ]

  @doc """
  Create a device struct for a device that is accessed via the local Wifi network.

  ## Options

  #{NimbleOptions.docs(@local_device_options_schema)}
  """
  def local_device(ip_or_host, opts \\ []) do
    opts = NimbleOptions.validate!(opts, @local_device_options_schema)
    %LocalDevice{host: ip_or_host, opts: opts}
  end

  @doc """
  Returns the system info.
  """
  def get_system_info(device) do
    command = %{
      system: %{get_sysinfo: nil}
    }

    with {:ok, result} <- TpLink.call(device, command) do
      {:ok, result |> Map.fetch!("system") |> Map.fetch!("get_sysinfo")}
    end
  end
end
