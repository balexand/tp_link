defprotocol TpLink.Device do
  # Protocol for implementing different ways to interface with devices, such as via the cloud or
  # local network
  @moduledoc false

  def call(device, command)
end
