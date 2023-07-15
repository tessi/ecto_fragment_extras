defmodule EctoNamedFragment.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_named_fragment,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "Ecto fragment() with named params instead of just ?'s"
  end

  defp deps do
    [
      {:nimble_parsec, "~> 1.3"},

      # Dev, Test
      {:ecto, "~> 3.10", only: [:dev, :test]},
      {:ex_doc, "~> 0.30.3", only: [:dev, :test]},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end
end
