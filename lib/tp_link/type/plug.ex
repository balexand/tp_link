defmodule TpLink.Type.Plug do
  def get_system_info(device) do
    command = %{
      system: %{get_sysinfo: nil}
    }

    with {:ok, result} <- TpLink.call(device, command) do
      {:ok, result |> Map.fetch!("system") |> Map.fetch!("get_sysinfo")}
    end
  end

  def set_relay_state(device, value) when is_boolean(value) do
    command = %{
      system: %{set_relay_state: %{state: boolean_to_number(value)}}
    }

    with {:ok, result} <- TpLink.call(device, command) do
      {:ok, result |> Map.fetch!("system") |> Map.fetch!("set_relay_state")}
    end
  end

  defp boolean_to_number(false), do: 0
  defp boolean_to_number(true), do: 1
end
