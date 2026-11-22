defmodule EctoFragmentExtrasConsumer.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_fragment_extras_consumer,
      version: "0.1.0",
      deps: [
        {:ecto_fragment_extras, path: ".."},
        {:ecto, System.fetch_env!("ECTO_VERSION")}
      ]
    ]
  end
end
