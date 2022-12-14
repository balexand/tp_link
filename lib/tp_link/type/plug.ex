defmodule TpLink.Type.Plug do
  @moduledoc """
  For working with smart plug devices.
  """

  @doc """
  Turns a switch on or off.
  """
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
