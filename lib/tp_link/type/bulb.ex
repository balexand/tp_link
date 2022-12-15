defmodule TpLink.Type.Bulb do
  @light_state_schema [
    brightness: [
      type: {:in, 0..100},
      doc: "Brightness (0-100)."
    ],
    color_temp: [
      type: {:in, 0..9000},
      doc: "Color temp in kelvin (0-9000). Must be set to `0` for color options to take effect."
    ],
    hue: [
      type: {:in, 0..360},
      doc: "Hue (0-360)."
    ],
    on_off: [
      type: :boolean,
      doc: "Boolean to turn bulb on/off."
    ],
    saturation: [
      type: {:in, 0..100},
      doc: "Saturation (0-100)."
    ]
  ]

  @doc """
  Sets the lighting state.

  ## Options

  #{NimbleOptions.docs(@light_state_schema)}
  """
  def set_light_state(device, opts) do
    light_state =
      opts
      |> NimbleOptions.validate!(@light_state_schema)
      |> Keyword.update(:on_off, nil, &boolean_to_number/1)
      |> Enum.filter(fn
        {_key, nil} -> false
        {_key, _value} -> true
      end)
      |> Map.new()

    command = %{
      "smartlife.iot.smartbulb.lightingservice": %{
        transition_light_state: light_state
      }
    }

    with {:ok, result} <- TpLink.call(device, command) do
      {:ok,
       result
       |> Map.fetch!("smartlife_iot_smartbulb_lightingservice")
       |> Map.fetch!("transition_light_state")}
    end
  end

  defp boolean_to_number(false), do: 0
  defp boolean_to_number(true), do: 1
end
