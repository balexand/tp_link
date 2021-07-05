defmodule TpLink.Cloud do
  @base_url "https://wap.tplinkcloud.com"

  def auth!(username, password) do
    uuid = UUID.uuid4()

    payload = %{
      method: "login",
      url: @base_url,
      params: %{
        appType: "Kasa_Android",
        cloudPassword: password,
        cloudUserName: username,
        terminalUUID: uuid
      }
    }

    url = "#{@base_url}?#{URI.encode_query(params(uuid: uuid))}"

    {:ok, %Finch.Response{body: body, status: 200}} =
      Finch.build(:post, url, headers(), Jason.encode!(payload)) |> Finch.request(TpLink.Finch)

    %{"error_code" => 0, "result" => result} = Jason.decode!(body)
    result
  end

  defp headers do
    [
      {"User-Agent", "Dalvik/2.1.0 (Linux; U; Android 6.0.1; A0001 Build/M4B30X)"},
      {"Content-Type", "application/json"}
    ]
  end

  defp params(opts) do
    %{
      appName: "Kasa_Android",
      termID: Keyword.fetch!(opts, :uuid),
      appVer: "1.4.4.607",
      ospf: "Android+6.0.1",
      netType: "wifi",
      locale: "es_ES"
    }
  end
end
