defmodule TpLink.Cloud do
  alias TpLink.Cloud.Token

  @base_url "https://wap.tplinkcloud.com"

  def auth!(username, password) do
    uuid = UUID.uuid4()

    %{"token" => token} =
      result =
      %{
        method: "login",
        url: @base_url,
        params: %{
          appType: "Kasa_Android",
          cloudPassword: password,
          cloudUserName: username,
          terminalUUID: uuid
        }
      }
      |> request(uuid: uuid)

    %Token{result: result, token: token, uuid: uuid}
  end

  def get_system_info(token, device) do
    %{
      system: %{get_sysinfo: nil},
      emeter: %{get_realtime: nil}
    }
    |> pass_through_request(token, device)
  end

  def list_devices(%Token{} = token) do
    %{method: "getDeviceList"}
    |> request(token)
    |> Map.fetch!("deviceList")
  end

  def pass_through_request(command, %Token{} = token, %{"deviceId" => device_id}) do
    %{
      method: "passthrough",
      params: %{
        deviceId: device_id,
        requestData: Jason.encode!(command)
      }
    }
    |> request(token)
    |> Map.fetch!("responseData")
    |> Jason.decode!()
  end

  defp request(%{} = payload, opts) do
    url = "#{@base_url}?#{URI.encode_query(params(opts))}"

    {:ok, %Finch.Response{body: body, status: 200}} =
      Finch.build(:post, url, headers(), Jason.encode!(payload))
      |> Finch.request(TpLink.Finch)

    %{"error_code" => 0, "result" => result} = Jason.decode!(body)
    result
  end

  defp headers do
    [
      {"User-Agent", "Dalvik/2.1.0 (Linux; U; Android 6.0.1; A0001 Build/M4B30X)"},
      {"Content-Type", "application/json"}
    ]
  end

  defp params(%Token{token: token, uuid: uuid}) do
    params(token: token, uuid: uuid)
    |> Keyword.put(:token, token)
  end

  defp params(opts) when is_list(opts) do
    [
      appName: "Kasa_Android",
      termID: Keyword.fetch!(opts, :uuid),
      appVer: "1.4.4.607",
      ospf: "Android+6.0.1",
      netType: "wifi",
      locale: "es_ES"
    ]
  end
end
