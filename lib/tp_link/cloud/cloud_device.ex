defmodule TpLink.Cloud.CloudDevice do
  # Device to be called via the cloud.
  @moduledoc false

  defstruct [:device_id, :session]

  defimpl TpLink.Device do
    alias TpLink.Cloud
    alias TpLink.Cloud.CloudDevice

    def call(%CloudDevice{device_id: device_id, session: session}, command) do
      Cloud.call(session, device_id, command)
    end
  end
end
