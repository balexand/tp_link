defmodule TpLink.Type.Plug do
  @moduledoc """
  For working with smart plug devices.
  """

  @doc """
  Returns `{:ok, is_on}` or `{:error, error}`.
  """
  def on?(device) do
    with {:ok, %{"relay_state" => relay_state}} <- TpLink.get_system_info(device) do
      {:ok, number_to_boolean(relay_state)}
    end
  end

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

  defp number_to_boolean(0), do: false
  defp number_to_boolean(1), do: true
end
