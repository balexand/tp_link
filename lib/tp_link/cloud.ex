defmodule TpLink.Cloud do
  @moduledoc """
  Documentation for `TpLink.Cloud`.
  """

  alias TpLink.Cloud.Session

  @url "https://wap.tplinkcloud.com"

  def call(%{} = command, %Session{} = session, device_id) when is_binary(device_id) do
    body = %{
      method: "passthrough",
      params: %{
        deviceId: device_id,
        requestData: Jason.encode!(command)
      }
    }

    with {:ok, result} <- request(session, body) do
      {:ok, Jason.decode!(result.response_data)}
    end
  end

  def list_devices(%Session{} = session) do
    with {:ok, result} <- request(session, %{method: "getDeviceList"}) do
      {:ok, result.device_list}
    end
  end

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
         account_id: result.account_id,
         country_code: result.country_code,
         email: result.email,
         registered_at: parse_datetime(result.reg_time),
         token: result.token,
         uuid: uuid
       }}
    end
  end

  defp parse_datetime(nil), do: nil

  defp parse_datetime(string) do
    {:ok, datetime, 0} = DateTime.from_iso8601(string <> "Z")
    datetime
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
        {:ok, Recase.Enumerable.atomize_keys(result, &Recase.to_snake/1)}

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
