defmodule TpLink.MixProject do
  use Mix.Project

  def project do
    [
      app: :tp_link,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TpLink.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_uuid, "~> 1.2"},
      {:finch, "~> 0.8.0"},
      {:jason, "~> 1.2"}
    ]
  end
end
