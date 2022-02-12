defmodule TpLink.Local.LocalDevice do
  defstruct [:host]

  defimpl TpLink.Device do
    alias TpLink.Local.LocalDevice

    def call(%LocalDevice{host: _host}, _command) do
      {:ok, _socket} = :gen_udp.open(0)
    end
  end
end
