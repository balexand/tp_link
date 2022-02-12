defprotocol TpLink.Device do
  @moduledoc false

  def call(device, command)
end
