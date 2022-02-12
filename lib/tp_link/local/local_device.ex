defmodule TpLink.Local.LocalDevice do
  defstruct [:host, :opts]

  defimpl TpLink.Device do
    alias TpLink.Local.{LocalDevice, Message}

    @port 9999

    def call(%LocalDevice{host: host, opts: opts}, command) do
      {:ok, socket} = :gen_udp.open(0, [:binary])

      :ok = :gen_udp.send(socket, host, @port, [Message.encode(command)])

      result =
        with {:ok, payload} <- receive_resp(socket, Keyword.fetch!(opts, :timeout)) do
          {:ok, Message.decode(payload) |> Recase.Enumerable.convert_keys(&Recase.to_snake/1)}
        end

      :ok = :gen_udp.close(socket)

      # There is a slight chance that the response packet arrived after the timeout or that the
      # device sent more than one reponse packet. This will ensure that stray messages are not
      # left in the current process's mailbox.
      flush(socket)

      result
    end

    defp flush(socket) do
      case receive_resp(socket, 0) do
        {:ok, _payload} -> flush(socket)
        {:error, :timeout} -> :ok
      end
    end

    defp receive_resp(socket, timeout) do
      receive do
        {:udp, ^socket, _from, _port, payload} -> {:ok, payload}
      after
        timeout -> {:error, :timeout}
      end
    end
  end
end
