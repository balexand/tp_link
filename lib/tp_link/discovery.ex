defmodule TpLink.Discovery do
  use GenServer

  alias TpLink.Message

  # @multicast_ip {224, 1, 1, 1}
  @multicast_ip {255, 255, 255, 255}
  @port 9999

  @discovery_msg %{
                   emeter: %{get_realtime: %{}},
                   "smartlife.iot.common.emeter": %{get_realtime: %{}},
                   system: %{get_sysinfo: %{}}
                 }
                 |> Message.encode()

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def discover(pid) do
    GenServer.call(pid, :discover)
  end

  @impl GenServer
  def init(:ok) do
    udp_options = [
      :binary,
      active: 10,
      add_membership: {@multicast_ip, {0, 0, 0, 0}},
      broadcast: true,
      ip: {0, 0, 0, 0},
      # multicast_if: {0, 0, 0, 0},
      multicast_loop: false,
      multicast_ttl: 1,
      reuseaddr: true
    ]

    # peerage
    # udp_options = [
    #   :binary,
    #   active: 10,
    #   add_membership: {@multicast_ip, {0, 0, 0, 0}},
    #   broadcast: true,
    #   ip: @ip,
    #   multicast_loop: true,
    #   multicast_ttl: @ttl,
    #   reuseaddr: true
    # ]

    {:ok, socket} = :gen_udp.open(@port, udp_options)

    {:ok, %{socket: socket}}
  end

  @impl GenServer
  def handle_call(:discover, _form, %{socket: socket} = state) do
    :ok = :gen_udp.send(socket, @multicast_ip, @port, [@discovery_msg])

    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_info({:udp, socket, ip, port, data}, state) do
    :inet.setopts(socket, active: 1)

    message = Message.decode(data)
    IO.inspect(["received", ip, port, message])

    {:noreply, state}
  end
end
