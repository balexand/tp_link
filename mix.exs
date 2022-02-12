defmodule TpLink.MixProject do
  use Mix.Project

  @version "0.0.1"

  def project do
    [
      app: :tp_link,
      description: "Interact with TP-Link/Kasa devices via the cloud or local network.",
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/balexand/tp_link"}
      ],
      docs: [
        extras: ["README.md"],
        main: "readme",
        source_ref: "v#{@version}",
        source_url: "https://github.com/balexand/tp_link"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:crypto, :logger],
      mod: {TpLink.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_uuid, "~> 1.2"},
      {:finch, "~> 0.10.2"},
      {:jason, "~> 1.3"},
      {:recase, "~> 0.7.0"},

      # dev/test deps
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false}
    ]
  end
end
