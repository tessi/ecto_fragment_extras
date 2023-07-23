defmodule EctoNamedFragment.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_named_fragment,
      version: "0.2.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
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
      # Dev, Test
      {:ecto, ">= 3.0.0", only: [:dev, :test]},
      {:ex_doc, "~> 0.30.3", only: [:dev, :test]},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end

  defp package() do
    [
      # These are the default files included in the package
      files: ~w[
        lib
        .formatter.exs
        mix.exs
        README.md
        LICENSE.md
        ],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/tessi/ecto_named_fragment",
        "Docs" => "https://hexdocs.pm/ecto_named_fragment"
      },
      source_url: "https://github.com/tessi/ecto_named_fragment"
    ]
  end
end
