defmodule TpLink.Local.DiscoveryServer do
  @moduledoc """
  A `GenServer` that discovers TP-Link devices on the local network. It works by periodically
  sending multicast UDP packets to all devices on the network and listening for responses.

  Once discovered, a device will remain in the list indefinitely even if it goes offline. This may
  change in a future release. At this time, I (@balexand) don't have any need for more
  sophisticated discovery functionality. Pleaes submit a pull-requeset or feature request if you
  need additional features.
  """

  use GenServer

  alias TpLink.Local.Message
  require Logger

  @interval 1000
  @multicast_ip {255, 255, 255, 255}
  @port 9999

  @discovery_msg %{system: %{get_sysinfo: %{}}} |> Message.encode()

  defmodule State do
    @moduledoc false
    defstruct devices: %{}, socket: nil
  end

  ##
  # Client API
  ##

  @doc """
  Starts the server. See `GenServer.start_link/3`.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Stops the server. See `GenServer.stop/1`.
  """
  def stop(pid), do: GenServer.stop(pid)

  @doc """
  Returns a list of devices that have been discovered by the server.
  """
  def list_devices(pid) do
    GenServer.call(pid, :list_devices)
    |> Enum.map(fn {ip, system_info} ->
      %{ip: ip, system_info: system_info}
    end)
  end

  ##
  # Server callbacks
  ##

  @impl GenServer
  def init(:ok) do
    send(self(), :broadcast)

    udp_options = [
      :binary,
      active: true,
      add_membership: {@multicast_ip, {0, 0, 0, 0}},
      broadcast: true,
      ip: {0, 0, 0, 0},
      multicast_loop: true,
      multicast_ttl: 1,
      reuseaddr: true
    ]

    {:ok, socket} = :gen_udp.open(0, udp_options)

    {:ok, %State{socket: socket}}
  end

  @impl GenServer
  def handle_call(:list_devices, _from, %State{devices: devices} = state) do
    {:reply, devices, state}
  end

  @impl GenServer
  def handle_info(:broadcast, %State{socket: socket} = state) do
    Process.send_after(self(), :broadcast, @interval)

    :ok = :gen_udp.send(socket, @multicast_ip, @port, [@discovery_msg])

    {:noreply, state}
  end

  def handle_info({:udp, socket, ip, _port, data}, %State{socket: socket} = state) do
    state =
      case Message.decode(data) do
        %{"system" => %{"get_sysinfo" => %{} = system_info}} ->
          system_info = Recase.Enumerable.convert_keys(system_info, &Recase.to_snake/1)

          %{state | devices: Map.put(state.devices, ip, system_info)}

        resp ->
          Logger.error("received invalid response: #{inspect(resp)}")
          state
      end

    {:noreply, state}
  end
end
