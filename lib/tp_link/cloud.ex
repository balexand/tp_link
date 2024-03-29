defmodule TpLink.Cloud do
  @moduledoc """
  For working with devices via [tplinkcloud.com](https://www.tplinkcloud.com/).
  """

  alias TpLink.Cloud.Session

  @url "https://wap.tplinkcloud.com"

  # Call this via `TpLink.call/2`
  @doc false
  def call(%Session{} = session, device_id, command) when is_binary(device_id) do
    body = %{
      method: "passthrough",
      params: %{
        deviceId: device_id,
        requestData: Jason.encode!(command)
      }
    }

    with {:ok, result} <- request(session, body) do
      response_data =
        result
        |> Map.fetch!("response_data")
        |> Jason.decode!()
        |> Recase.Enumerable.convert_keys(&Recase.to_snake/1)

      {:ok, response_data}
    end
  end

  @doc """
  Returns a list of available devices.
  """
  def list_devices(%Session{} = session) do
    with {:ok, result} <- request(session, %{method: "getDeviceList"}) do
      {:ok, Map.fetch!(result, "device_list")}
    end
  end

  @doc """
  Authenticates with TP-Link Cloud. Use the same username and password that you use to sign in to
  [tplinkcloud.com](https://www.tplinkcloud.com/).
  """
  def login(username, password) do
    uuid = UUID.uuid4()

    body = %{
      method: "login",
      params: %{
        appType: "Kasa_Android",
        cloudPassword: password,
        cloudUserName: username,
        terminalUUID: uuid
      }
    }

    with {:ok, result} <- request(nil, body) do
      {:ok,
       %Session{
         token: Map.fetch!(result, "token"),
         uuid: uuid
       }}
    end
  end

  defp request(session, %{} = body) do
    headers = [
      {"user-agent", "Dalvik/2.1.0 (Linux; U; Android 6.0.1; A0001 Build/M4B30X)"},
      {"content-type", "application/json"}
    ]

    url = "#{@url}?#{params(session) |> URI.encode_query()}"

    {:ok, %Finch.Response{body: body, status: 200}} =
      Finch.build(:post, url, headers, Jason.encode!(body))
      |> Finch.request(TpLink.Finch)

    case Jason.decode!(body) do
      %{"error_code" => 0, "result" => result} ->
        {:ok, Recase.Enumerable.convert_keys(result, &Recase.to_snake/1)}

      %{"error_code" => code, "msg" => msg} ->
        {:error, %{code: code, message: msg}}
    end
  end

  defp params(nil) do
    %{
      appName: "Kasa_Android",
      appVer: "1.4.4.607",
      ospf: "Android+6.0.1",
      netType: "wifi",
      locale: "es_ES"
    }
  end

  defp params(session) do
    params(nil)
    |> Map.merge(%{
      termID: session.uuid,
      token: session.token
    })
  end
end
