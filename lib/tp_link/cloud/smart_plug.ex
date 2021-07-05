defmodule TpLink.Cloud.SmartPlug do
  alias TpLink.Cloud

  defmodule SystemInfo do
    defstruct [:relay_state, :sysinfo]
  end

  def get_system_info(token, device) do
    %{"relay_state" => relay_state} =
      sysinfo =
      %{
        system: %{get_sysinfo: nil}
      }
      |> Cloud.pass_through_request(token, device)
      |> Map.fetch!("system")
      |> Map.fetch!("get_sysinfo")

    %SystemInfo{
      relay_state:
        case relay_state do
          0 -> false
          1 -> true
        end,
      sysinfo: sysinfo
    }
  end

  def set_relay_state(token, device, state) when is_boolean(state) do
    %{system: %{set_relay_state: %{state: if(state, do: 1, else: 0)}}}
    |> Cloud.pass_through_request(token, device)
  end
end
