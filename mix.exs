defmodule EctoFragmentExtras.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_fragment_extras,
      version: "0.3.0",
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
    "A collection of macros to enhance Ectos fragment()"
  end

  defp deps do
    [
      # Dev, Test
      {:ecto, ">= 3.0.0", only: [:dev, :test]},
      {:ex_doc, "~> 0.37.1", only: [:dev, :test]},
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
        "GitHub" => "https://github.com/tessi/ecto_fragment_extras",
        "Docs" => "https://hexdocs.pm/ecto_fragment_extras"
      },
      source_url: "https://github.com/tessi/ecto_fragment_extras"
    ]
  end
end
