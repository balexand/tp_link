defmodule TpLink.Cloud.Session do
  # Session struct containing credentials needed to make cloud API calls.
  @moduledoc false

  defstruct [:token, :uuid]
end
