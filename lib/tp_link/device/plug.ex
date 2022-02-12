defmodule TpLink.Device.Plug do
  def get_system_info do
    %{
      system: %{get_sysinfo: nil}
    }
  end

  def set_relay_state(value) when is_boolean(value) do
    %{
      system: %{set_relay_state: %{state: boolean_to_number(value)}}
    }
  end

  defp boolean_to_number(false), do: 0
  defp boolean_to_number(true), do: 1
end
